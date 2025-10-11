data "aws_subnets" "private_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.existing_vpc_id]
  }

  tags = {
    "${var.tag_subnet_key}" = "${var.tag_subnet_value}"
  }
}

data "aws_subnets" "public_subnets" {
  filter {
    name   = "vpc-id"
    values = [var.existing_vpc_id]
  }

  tags = {
    "karpenter.sh/discovery" = local.cluster_name
    Name                     = local.public_subnets-prefix
  }
}
