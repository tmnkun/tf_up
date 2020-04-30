provider "aws" {
  region  = "us-east-2"
  profile = "default"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "tmnkun-tf-up-state"

  # Protect to destroy
  lifecycle {
    prevent_destroy = true
  }

  # Enable version history
  versioning {
    enabled = true
  }

  # Enable crypt to default server side
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = "tf-up-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

terraform {
  backend "s3" {
    bucket          = "tmnkun-tf-up-state"
    key             = "global/s3/terraform.tfstate"
    region          = "us-east-2"
    dynamodb_table  = "tf-up-locks"
    encrypt         = true
  }
}

output "s3_bucket_arn" {
  value       = "aws_s3_bucket.terraform_state.arn"
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = "aws_dynamodb_table.terraform_locks.name"
  description = "The name of the DynamoDB table"
}
