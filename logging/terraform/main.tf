terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "production" {
  name = var.cluster_name
}

data "aws_iam_openid_connect_provider" "eks" {
  url = data.aws_eks_cluster.production.identity[0].oidc[0].issuer
}

resource "aws_iam_role" "loki" {
  name = "production-observability-loki-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Federated = data.aws_iam_openid_connect_provider.eks.arn
        }

        Action = "sts:AssumeRoleWithWebIdentity"

        Condition = {
          StringEquals = {
            "${replace(data.aws_eks_cluster.production.identity[0].oidc[0].issuer, "https://", "")}:aud" = "sts.amazonaws.com"

            "${replace(data.aws_eks_cluster.production.identity[0].oidc[0].issuer, "https://", "")}:sub" = "system:serviceaccount:monitoring:loki"
          }
        }
      }
    ]
  })
}

resource "aws_iam_policy" "loki_s3" {
  name = "production-observability-loki-s3"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.loki_chunks.arn,
          aws_s3_bucket.loki_ruler.arn
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "${aws_s3_bucket.loki_chunks.arn}/*",
          "${aws_s3_bucket.loki_ruler.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "loki_s3" {
  role       = aws_iam_role.loki.name
  policy_arn = aws_iam_policy.loki_s3.arn
}

resource "aws_s3_bucket" "loki_chunks" {
  bucket = var.loki_chunks_bucket
}

resource "aws_s3_bucket" "loki_ruler" {
  bucket = var.loki_ruler_bucket
}
