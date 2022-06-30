##################################################### Compliant Resource ######################################################################

data "aws_canonical_user_id" "current" {}

data "aws_iam_policy_document" "s3_compliant_bucket_policy" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  statement {
    actions       = ["s3:GetBucketAcl"]
    effect        = "Allow"
    resources     = [aws_s3_bucket.S3_Compliant_Bucket[count.index].arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com","config.amazonaws.com"]
    }
  }
  statement {
    actions       = ["s3:PutObject"]
    effect        = "Allow"
    resources     = [join("",["",aws_s3_bucket.S3_Compliant_Bucket[count.index].arn,"/*"])]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com","config.amazonaws.com"]
    }
    condition {
      test        = "StringEquals"
      variable    = "s3:x-amz-acl"
      values      = ["bucket-owner-full-control"]
    }
  }
  statement {
    actions       = ["s3:*"]
    effect        = "Deny"
    resources     = [join("",["",aws_s3_bucket.S3_Compliant_Bucket[count.index].arn,"/*"])]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test        = "Bool"
      variable    = "aws:SecureTransport"
      values      = ["false"]
    }
  }
  statement {
    actions       = ["s3:PutObject"]
    effect        = "Deny"
    resources     = [join("",["",aws_s3_bucket.S3_Compliant_Bucket[count.index].arn,"/*"])]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test        = "Null"
      variable    = "s3:x-amz-server-side-encryption"
      values      = ["true"]
    }
    condition {
      test        = "Bool"
      variable    = "aws:SecureTransport"
      values      = ["false"]
    }
  }
}

resource "aws_s3_bucket" "S3_Compliant_Bucket" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = "${var.env_name}-${var.infra_type}-s3-bucket-${count.index + 1}"
  force_destroy   = true

  object_lock_configuration {
    object_lock_enabled = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "Compliant_Bucket_Versioning" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].id
  versioning_configuration {
    status        = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "Compliant_Bucket_BlockPublicAccess" {
  count                   = var.infra_type == "compliant" ? var.var_count : 0
  bucket                  = aws_s3_bucket.S3_Compliant_Bucket[count.index].id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
  depends_on              = [ aws_s3_bucket_policy.Compliant_Bucket_Policy ]
}

resource "aws_s3_bucket_policy" "Compliant_Bucket_Policy" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].id
  policy          = data.aws_iam_policy_document.s3_compliant_bucket_policy[count.index].json
}

resource "aws_s3_bucket_logging" "Compliant_Bucket_Logging" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].id

  target_bucket   = aws_s3_bucket.S3_Compliant_Bucket[count.index].id
  target_prefix   = "log/"
}

resource "aws_s3_bucket_lifecycle_configuration" "Compliant_Bucket_Config" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].bucket

  rule {
    id            = "Log files transition and expiration"
    expiration {
      days        = 365
    }
    filter {
      and {
        prefix    = "app-logs/"
        tags = {
          rule      = "log"
          autoclean = "true"
        }
      }
    }
    status        = "Enabled"
    transition {
      days          = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days          = 60
      storage_class = "GLACIER"
    }
  }
}

resource "aws_s3_bucket_accelerate_configuration" "Compliant_Bucket_Accelaration_Config" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].bucket
  status          = "Enabled"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "Compliant_Bucket_Encryption" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].bucket

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id =  var.kms_key
      sse_algorithm     =  "aws:kms" #"AES256"
    }
  }
}

resource "aws_s3_bucket_acl" "Compliant_Bucket_acl" {
  count           = var.infra_type == "compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Compliant_Bucket[count.index].id
  access_control_policy {
    grant {
      grantee {
        id        = data.aws_canonical_user_id.current.id
        type      = "CanonicalUser"
      }
      permission  = "READ"
    }

    grant {
      grantee {
        type      = "Group"
        uri       = "http://acs.amazonaws.com/groups/s3/LogDelivery"
      }
      permission  = "READ_ACP"
    }

    owner {
      id          = data.aws_canonical_user_id.current.id
    }
  }
}

####################################################### Non-Compliant Resources ################################################################

data "aws_iam_policy_document" "s3_noncompliant_bucket_policy" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  statement {
    actions       = ["s3:GetBucketAcl"]
    effect        = "Allow"
    resources     = [aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].arn]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com","config.amazonaws.com"]
    }
  }
  statement {
    actions       = ["s3:PutObject"]
    effect        = "Allow"
    resources     = [join("",["",aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].arn,"/*"])]
    principals {
      type        = "Service"
      identifiers = ["cloudtrail.amazonaws.com","config.amazonaws.com"]
    }
    condition {
      test        = "StringEquals"
      variable    = "s3:x-amz-acl"
      values      = ["bucket-owner-full-control"]
    }
  }
  statement {
    actions       = ["s3:*"]
    effect        = "Allow"
    resources     = [join("",["",aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].arn,"/*"])]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test        = "Bool"
      variable    = "aws:SecureTransport"
      values      = ["false"]
    }
  }
  statement {
    actions       = ["s3:PutObject"]
    effect        = "Allow"
    resources     = [join("",["",aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].arn,"/*"])]
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    condition {
      test        = "Null"
      variable    = "s3:x-amz-server-side-encryption"
      values      = ["true"]
    }
    condition {
      test        = "Bool"
      variable    = "aws:SecureTransport"
      values      = ["false"]
    }
  }
}

resource "aws_s3_bucket" "S3_Non_Compliant_Bucket" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  bucket          = "${var.env_name}-${var.infra_type}-bucket-${count.index + 1}"
  force_destroy   = true
}

resource "aws_s3_bucket_versioning" "versioning" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].id
  versioning_configuration {
    status        = "Suspended"
  }
}

resource "aws_s3_bucket_public_access_block" "Non_Compliant_Bucket_BlockPublicAccess" {
  count                   = var.infra_type == "non-compliant" ? var.var_count : 0
  bucket                  = aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
  depends_on              = [ aws_s3_bucket_policy.Non_Compliant_BucketPolicy ]
}

resource "aws_s3_bucket_policy" "Non_Compliant_BucketPolicy" {
  count                   = var.infra_type == "non-compliant" ? var.var_count : 0
  bucket                  = aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].id
  policy                  = data.aws_iam_policy_document.s3_noncompliant_bucket_policy[count.index].json
}

resource "aws_s3_bucket_accelerate_configuration" "Non_Compliant_Bucket_Accelaration_Config" {
  count           = var.infra_type == "non-compliant" ? var.var_count : 0
  bucket          = aws_s3_bucket.S3_Non_Compliant_Bucket[count.index].bucket
  status          = "Suspended"
}