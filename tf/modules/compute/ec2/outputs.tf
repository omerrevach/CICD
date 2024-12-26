output "instance_id" {
  value = aws_instance.instance.id
}

output "security_group_id" {
  value = aws_security_group.instance_sg.id
}

# output "public_ip" {
#   value = aws_eip.eip.public_ip
# }
