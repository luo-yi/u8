resource "aws_s3_bucket" "artifacts" {
  bucket        = var.artifact_bucket_name
  acl           = "private"
  force_destroy = true
}


# ------------------------------ Code Pipeline ------------------------------ #
# --------------------------------------------------------------------------- #
resource "aws_codepipeline" "this" {
  name     = var.codepipeline_name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = aws_s3_bucket.artifacts.bucket
    type     = "S3"

  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner      = var.github_username
        Repo       = var.github_rep_name
        Branch     = "main"
        OAuthToken = var.github_token
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = var.codebuild_name
      }
    }
  }

  stage {
    name = "Deploy-Staging"

    action {
      name            = "Deploy-Staging"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.staging.bucket
        Extract    = "true"
      }
    }
  }

  stage {
    name = "Promote-To-Production"

    action {
      name     = "Promote-To-Production"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"
    }
  }

  stage {
    name = "Deploy-Production"

    action {
      name            = "Deploy-Production"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "S3"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        BucketName = aws_s3_bucket.production.bucket
        Extract    = "true"
      }
    }
  }
}


# ------------------------------- Code Build -------------------------------- #
# --------------------------------------------------------------------------- #
resource "aws_codebuild_project" "this" {
  name          = var.codebuild_name
  description   = var.codebuild_name
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:4.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  source {
    type = "CODEPIPELINE"
  }
}

