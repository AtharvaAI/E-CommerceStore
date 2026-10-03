resource "aws_security_group" "ecommerce" {
  name        = "ecommerce-sg"
  description = "Security group for E-Commerce Docker host"
  vpc_id      = aws_vpc.ecommerce.id

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Frontend
  ingress {
    description = "Frontend"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Backend services - internal
  ingress {
    description = "Backend services"
    from_port   = 3001
    to_port     = 3004
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  # MongoDB internal
  ingress {
    description = "MongoDB"
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecommerce-sg"
  }
}
