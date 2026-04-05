output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}

output "app_url" {
  value = "http://${aws_instance.myapp-server.public_ip}:8080"
}
