###############################
# Terraform remote state infra
# S3 bucket + DynamoDB lock
###############################

# S3 bucket to store Terraform state
resource "aws_s3_bucket" "tf_state" {
  # لازم يكون اسم فريد عالميًا
  bucket = "hager-tf-state-222735209716-us-east-1"

  force_destroy = true

  tags = {
    Name        = "hager-terraform-state"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

# Block public access (best practice)
resource "aws_s3_bucket_public_access_block" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable versioning
resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# DynamoDB table for state locking
resource "aws_dynamodb_table" "tf_locks" {
  name         = "hager-terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "hager-terraform-locks"
    Environment = "dev"
    ManagedBy   = "Terraform"
  }
}

