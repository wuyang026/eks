# cluster Variables
project_name     = "go-ph2-00"
aws_region       = "ap-south-1"
existing_vpc_id  = "vpc-0af4b08fb5339474e"
cluster_k8s_version = "1.34"
environment      = "dev"

# subnet tags (subnet作成する時にtag「karpenter.sh/discovery」の値を設定)
#例「karpenter.sh/discovery: {project_name}-dev-eks-cluster」
tag_subnet_value = "go-ph2-00-dev-eks-cluster"

# cluster security group
cluster_sg_ingress_rules = [
  {description = "",from_port = 0,to_port = 0,protocol = "-1",cidr_blocks = ["65.0.72.0/24"]},
  {description = "",from_port = 0,to_port = 0,protocol = "-1",cidr_blocks = ["192.178.0.0/24"]},
  {description = "",from_port = 0,to_port = 0,protocol = "-1",cidr_blocks = ["192.178.8.0/24"]},
  {description = "",from_port = 0,to_port = 0,protocol = "-1",cidr_blocks = ["192.178.9.0/24"]},
  {description = "",from_port = 0,to_port = 0,protocol = "-1",cidr_blocks = ["192.178.10.0/24"]},
]

# node security group tags (security group作成する時にtagを設定)
node_sg_ingress_rules = [
  {description = "",from_port = 0,to_port = 0,protocol = "-1",cidr_blocks = ["192.178.0.0/24"]}
]

# public endpoint access cidrs
endpoint_public_access_cidrs = []

# ecr Variables
ecr_repo_name         = "ecr-test"

# efs csi driver version
efs_csi_driver_version = "v2.1.12-eksbuild.1"

# node pool Variables
instance_architecture = ["amd64","arm64"]
capacity_type = ["SPOT","on-demand"]
instance_cpu = ["2","4","8"]
instance_category = ["t","c","m","r"]