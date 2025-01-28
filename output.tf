# output Ids of security groups in order to use them in other modules
output "ssh_sg_id" {
  value = aws_security_group.ssh.id
}

output "ping_sg_id" {
  value = aws_security_group.ping.id
}

output "http_sg_id" {
  value = aws_security_group.http.id
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

