output "public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "private_ip" {
  description = "Private IP of the web server"
  value       = aws_instance.web.private_ip
}

