# ECR repository作成
resource "aws_ecr_repository" "ecr_repo" {
  name = var.ecr_repo_name
  image_scanning_configuration {
    scan_on_push = true
  }
  depends_on = [kubectl_manifest.karpenter_node_pool]
}