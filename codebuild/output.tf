output "codebuild_badge_url" {
  value = aws_codebuild_project.self.badge_url
}

output "ecr_name" {
  value = aws_ecr_repository.self.name
}