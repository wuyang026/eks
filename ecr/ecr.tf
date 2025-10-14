# ECR repository作成
resource "aws_ecr_repository" "repo" {
  for_each = toset(var.ecr_repo_names)

  name = each.key

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name        = each.key
    Environment = var.environment
  }
}
