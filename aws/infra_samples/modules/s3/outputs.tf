output "out_s3_self_link" {
  description     = "S3 bucket name"
  value           = var.infra_type == "compliant" ? aws_s3_bucket.S3_Compliant_Bucket[0].id : aws_s3_bucket.S3_Non_Compliant_Bucket[0].id
}