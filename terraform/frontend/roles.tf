# ------------------------------ Code Pipeline ------------------------------ #
# --------------------------------------------------------------------------- #
resource "aws_iam_role" "codepipeline" {
  name               = "codepipeline_role"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume_role.json
}


resource "aws_iam_role_policy" "codepipeline" {
  name   = "codepipeline_policy"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline.json
}


data "aws_iam_policy_document" "codepipeline_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "codepipeline" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:PutObject",
    ]
    resources = [
      aws_s3_bucket.staging.arn,
      "${aws_s3_bucket.staging.arn}/*",
      aws_s3_bucket.production.arn,
      "${aws_s3_bucket.production.arn}/*",
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild",
    ]
    resources = ["*"]
  }
}


# ------------------------------- Code Build -------------------------------- #
# --------------------------------------------------------------------------- #
resource "aws_iam_role" "codebuild" {
  name               = "codebuild_role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}


resource "aws_iam_role_policy" "codebuild" {
  name   = "codebuild_policy"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild.json
}


data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}


data "aws_iam_policy_document" "codebuild" {
  statement {
    effect    = "Allow"
    actions   = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:GetBucketAcl",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.staging.arn,
      "${aws_s3_bucket.staging.arn}/*",
      aws_s3_bucket.production.arn,
      "${aws_s3_bucket.production.arn}/*",
      aws_s3_bucket.artifacts.arn,
      "${aws_s3_bucket.artifacts.arn}/*",
    ]
  }

  statement {
    effect    = "Allow"
    actions   = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["*"]
  }
}
