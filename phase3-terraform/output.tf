output "ec2_public_ip" {
  value = aws_instance.app_server.public_ip
}

output "alb_dns_name" {
  value = aws_lb.app_alb.dns_name
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}

output "vpc_id" {
  value = aws_vpc.electrogo_vpc.id
}