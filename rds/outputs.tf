output "rds_address" {
  value       = aws_db_instance.rds.address
  description = "RDS domain name"
  sensitive   = true
}
