variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "your_name" {
  description = "Name to show on the web page"
  type        = string
  default     = "Hager Gamal"
}
