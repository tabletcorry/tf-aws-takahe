resource "aws_codebuild_project" "self" {
  name          = var.name
  build_timeout = "7"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/amazonlinux2-aarch64-standard:2.0"
    type                        = "ARM_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = true
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.self.account_id
    }
    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = data.aws_region.self.name
    }
    environment_variable {
      name  = "IMAGE_REPO_NAME"
      value = aws_ecr_repository.self.name
    }
    environment_variable {
      name  = "IMAGE_TAG"
      value = "latest"
    }
  }

  concurrent_build_limit = 1

  /*logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }
  }*/

  badge_enabled = true

  source {
    type            = "GITHUB"
    location        = var.github_url
    git_clone_depth = 1

    report_build_status = true

    git_submodules_config {
      fetch_submodules = true
    }

    buildspec = file("${path.module}/buildspec.yml")
  }

  source_version = "main"
}

resource "aws_codebuild_webhook" "self" {
  project_name = aws_codebuild_project.self.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = "main"
    }
  }
}