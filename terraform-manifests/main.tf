module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.1"

  kubernetes_version = var.cluster_k8s_version
  name    = local.cluster_name

  endpoint_public_access                   = true
  enable_irsa                              = true
  enable_cluster_creator_admin_permissions = true
  create_auto_mode_iam_resources           = true

  # kms無効
  create_kms_key = false
  encryption_config = null

  compute_config = {
    enabled    = true
  }

  vpc_id                    = var.existing_vpc_id
  subnet_ids                = data.aws_subnets.private_subnets.ids

  # cluster security group指定
  create_security_group = false
  additional_security_group_ids = var.existing_security_cluster_group_ids

  # node security group自動作成不要、node classにカスタムsgを指定
  create_node_security_group = false

  # パブリックアクセス指定
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs

  cloudwatch_log_group_retention_in_days = 30

  tags = local.common_tags
}

resource "aws_eks_access_entry" "auto_mode" {
  cluster_name  = module.eks.cluster_name
  principal_arn = module.eks.node_iam_role_arn
  type          = "EC2"
}

resource "aws_eks_access_policy_association" "auto_mode" {
  cluster_name  = module.eks.cluster_name
  policy_arn    = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSAutoNodePolicy"
  principal_arn = module.eks.node_iam_role_arn
  access_scope {
    type = "cluster"
  }
  depends_on = [aws_eks_access_entry.auto_mode]
}

resource "time_sleep" "wait_10_seconds" {
  depends_on = [aws_eks_access_policy_association.auto_mode]
  create_duration = "10s"
}

# Node class作成
resource "kubectl_manifest" "karpenter_node_class" {
  yaml_body = templatefile("${path.module}/node_file/node-class.yaml", {
    eks_cluster_name     = module.eks.cluster_name
    eks_auto_node_policy = module.eks.node_iam_role_name
    node_class_name      = local.node_class_name
    tag_subnet_key       = var.tag_subnet_key
    tag_subnet_value     = var.tag_subnet_value
    tag_node_sg_key      = var.tag_node_sg_key
    tag_node_sg_value    = var.tag_node_sg_value
  })
  depends_on = [module.eks.cluster_endpoint,module.eks.node_iam_role_name,time_sleep.wait_10_seconds]
}

# Node pool作成
resource "kubectl_manifest" "karpenter_node_pool" {
  for_each = toset(var.instance_architecture)
  yaml_body = templatefile("${path.module}/node_file/node-pool.yaml", {
    node_class_name       = local.node_class_name
    node_pool_name        = "${local.node_pool_name}-${each.value}"
    instance_cpu          = "${join("\", \"", var.instance_cpu)}"
    instance_category     = "${join("\", \"", var.instance_category)}"
    capacity_type         = "${join("\", \"", var.capacity_type)}"
    instance_size         = "${join("\", \"", var.instance_size)}"
    instance_architecture = each.value
    taints_key            = "${local.node_pool_name}-${each.value}"
  })
  depends_on = [kubectl_manifest.karpenter_node_class, module.eks]
}

# ECR repository作成
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repo_name
  image_scanning_configuration {
    scan_on_push = true
  }
  depends_on = [kubectl_manifest.karpenter_node_pool]
}

# EKSアドオンのインストール時に異常が発生しないように、自動で削除されるPodを作成し、ノードを起動
resource "kubectl_manifest" "sample_pod" {
  yaml_body = file("${path.module}/sample_pod/sample_pod.yaml")
  depends_on = [kubectl_manifest.karpenter_node_pool]
}

# ノードの起動が完了するまで待機
resource "time_sleep" "wait_180_seconds" {
  depends_on = [kubectl_manifest.sample_pod]
  create_duration = "180s"
}

# EFS CSIドライバーインストール
module "aws_efs_csi_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "2.0.0"
  name             = "${module.eks.cluster_name}-efs-role"
  additional_policy_arns = {
    AmazonEFSCSIDriverPolicy = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
  }
  depends_on = [time_sleep.wait_180_seconds]
}

resource "aws_eks_pod_identity_association" "efs_csi" {
  cluster_name    = module.eks.cluster_name
  namespace       = "kube-system"
  service_account = "efs-csi-controller-sa"
  role_arn        =  module.aws_efs_csi_pod_identity.iam_role_arn
  depends_on = [module.aws_efs_csi_pod_identity.iam_role_arn]
}

resource "aws_eks_addon" "efs_csi" {
  cluster_name             = module.eks.cluster_name
  addon_name               = "aws-efs-csi-driver"
  addon_version            = var.efs_csi_driver_version
  service_account_role_arn = module.aws_efs_csi_pod_identity.iam_role_arn
  resolve_conflicts_on_update = "OVERWRITE"

  tags = {
    Name = "efs-csi-addon"
  }
  depends_on = [aws_eks_pod_identity_association.efs_csi]
}
