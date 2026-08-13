variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "cluster_name" {
  type    = string
  default = "production-eks-cluster"
}

variable "loki_chunks_bucket" {
  type = string
}

variable "loki_ruler_bucket" {
  type = string
}
