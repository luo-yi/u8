variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "artifact_bucket_name" {
  type    = string
  default = "unit8-frontend-artifacts"
}

variable "staging_bucket_name" {
  type    = string
  default = "unit8-staging.rgf-harpur.com"
}

variable "production_bucket_name" {
  type    = string
  default = "unit8.rgf-harpur.com"
}

variable "codepipeline_name" {
  type    = string
  default = "unit8-frontend-pipeline"
}

variable "codebuild_name" {
  type    = string
  default = "unit8-frontend-builder"
}

variable "github_username" {
  type = string
}

variable "github_rep_name" {
  type = string
}

variable "github_token" {
  type = string
}
