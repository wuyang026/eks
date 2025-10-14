# cluster Variables
project_name     = "go-ph2-00"
aws_region       = "ap-south-1"
existing_vpc_id  = "vpc-0af4b08fb5339474e"
cluster_k8s_version = "1.34"
environment      = "dev"

# subnet tags (subnet作成する時にtagを設定)
tag_subnet_key = "usedby"
tag_subnet_value = "dev"

# cluster security group id
existing_security_cluster_group_ids = ["sg-08ab9415cb5fa3acb"]

# node security group tags (security group作成する時にtagを設定)
tag_node_sg_key = "Name"
tag_node_sg_value = "go-dev-eks-node-sg"

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
