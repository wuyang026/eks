# cluster Variables
project_name     = "go-ph2-00"
aws_region       = "ap-northeast-1"
existing_vpc_id  = "vpc-0031c9c242f118fc0"
cluster_k8s_version = "1.34"
environment      = "dev"

# subnet tags
tag_subnet_key = "Usedby"
tag_subnet_value = "dev-pri"

# cluster security group id
existing_security_cluster_group_ids = ["sg-0fd540a36ffcce8c7"]

# node security group tags
tag_node_sg_key = "Name"
tag_node_sg_value = "go-dev-eks-cluster-node"

# ecr Variables
ecr_repo_name         = "ecr-test"

# efs csi driver version
efs_csi_driver_version = "v2.1.12-eksbuild.1"

# node pool Variables
instance_architecture = ["amd64","arm64"]
capacity_type = ["SPOT","on-demand"]
instance_cpu = ["2","4","8"]
instance_category = ["t","c","m","r"]
instance_size = ["medium","large","xlarge"]