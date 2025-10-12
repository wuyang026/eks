data "aws_eks_cluster" "cluster" {
  name       = module.eks.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name       = module.eks.cluster_name
}

provider "kubectl" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.this.token
  load_config_file       = false
}

#data "aws_caller_identity" "current" {}

#provider "kubectl" {
#  config_path    = "~/.kube/config"
#  config_context = "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks.cluster_name}"
#}

provider "aws" {
  region  = var.aws_region
  profile = "default"

}

provider "null" {}
