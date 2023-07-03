resource "aws_dynamodb_table" "state_locking" {
  name           = var.table_name
  hash_key       = "LockID"
  read_capacity  = 10
  write_capacity = 10
  attribute {
    name = "LockID"
    type = "S"
  }
}
