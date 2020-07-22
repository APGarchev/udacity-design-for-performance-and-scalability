output "vpc_id" {
  value = aws_vpc.main.id
}
output "public_subnet_id" {
  value = aws_subnet.public.id
}
output "allow_ssh_security_group_id" {
  value = aws_security_group.allow_ssh.id
}
output "allow_http_security_group_id" {
  value = aws_security_group.allow_http.id
}