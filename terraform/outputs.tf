output "instance_id" {
  value = aws_instance.ecommerce.id
}

output "public_ip" {
  value = aws_instance.ecommerce.public_ip
}

output "frontend_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3000"
}

output "user_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3001"
}

output "product_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3002"
}

output "cart_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3003"
}

output "order_service_url" {
  value = "http://${aws_instance.ecommerce.public_ip}:3004"
}
