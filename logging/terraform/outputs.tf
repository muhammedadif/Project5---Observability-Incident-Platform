output "loki_role_arn" {
  value = aws_iam_role.loki.arn
}

output "loki_chunks_bucket" {
  value = aws_s3_bucket.loki_chunks.bucket
}

output "loki_ruler_bucket" {
  value = aws_s3_bucket.loki_ruler.bucket
}
