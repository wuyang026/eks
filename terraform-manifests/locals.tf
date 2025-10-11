# Define Local Values in Terraform
locals {
  name                    = "${var.project_name}-${var.environment}"
  prefix_env              = "${local.name}-${var.cluster_prefix}"
  cluster_name            = "${local.prefix_env}-cluster"
  private_subnets-prefix  = "${local.cluster_name}-private-subnet"
  public_subnets-prefix   = "${local.cluster_name}-public-subnet"
  node_class_name         = "${local.prefix_env}-nodeclass"
  node_pool_name          = "${local.prefix_env}-nodepool"

  common_tags = {
    owners      = var.project_name
    environment = var.environment
    Terraform   = "true"
  }
} 