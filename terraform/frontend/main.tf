provider "aws" {
  region = var.region
}


resource "aws_s3_bucket" "staging" {
  bucket        = var.staging_bucket_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}


resource "aws_s3_bucket" "production" {
  bucket        = var.production_bucket_name
  acl           = "public-read"
  force_destroy = true

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = []
    max_age_seconds = 3000
  }
}

# ----------------------------- Bucket Policies ----------------------------- #
# --------------------------------------------------------------------------- #
data "aws_iam_policy_document" "staging_bucket" {
  statement {
    resources = ["arn:aws:s3:::${var.staging_bucket_name}/*"]
    actions   = ["s3:GetObject"]
    effect    = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


resource "aws_s3_bucket_policy" "staging" {
  bucket = aws_s3_bucket.staging.id
  policy = data.aws_iam_policy_document.staging_bucket.json
}


data "aws_iam_policy_document" "production_bucket" {
  statement {
    resources = ["arn:aws:s3:::${var.production_bucket_name}/*"]
    actions   = ["s3:GetObject"]
    effect    = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


resource "aws_s3_bucket_policy" "production" {
  bucket = aws_s3_bucket.production.id
  policy = data.aws_iam_policy_document.production_bucket.json
}
