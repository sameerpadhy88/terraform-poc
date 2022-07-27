
# create bucket along with tag
resource "aws_s3_bucket" "pocBucket" {
    bucket = "${var.bucketname}-${var.environemnt}"
    tags = {
      "Project" = "value"
      "Environment" = "${var.environemnt}"
      "Type" = "value"
      "Classification" = "value"
    }
    
}

# apply encryption key
resource "aws_s3_bucket_server_side_encryption_configuration" "pocbucketencryption" {
  bucket = aws_s3_bucket.pocBucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.pocmykey.arn
      sse_algorithm = "aws:kms"
    }
  }
}

# bucket and objects not public
resource "aws_s3_bucket_public_access_block" "pocbucketaccessblock" {
  bucket = aws_s3_bucket.pocBucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# create kms key
resource "aws_kms_key" "pocmykey" {
    deletion_window_in_days = 10  
}

# enable versioning
resource "aws_s3_bucket_versioning" "pocbucketversioning" {
  bucket = aws_s3_bucket.pocBucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
