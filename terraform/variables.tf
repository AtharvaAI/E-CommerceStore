variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
}

variable "docker_username" {
  description = "Docker Hub username"
  type        = string
  default     = "prassanaganesh"
}
