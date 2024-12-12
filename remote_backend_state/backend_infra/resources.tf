resource "aws_dynamodb_table" "state_table" {
  name = var.state_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
  tags = {
    Name = var.state_table_name
  }
}

resource "aws_s3_bucket" "state_bucket" {
  bucket = var.state_bucket_name
  tags = {
    Name = var.state_bucket_name
  }
}