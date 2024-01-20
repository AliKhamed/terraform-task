variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "provider_region" {
  type    = string
  default = "us-east-1"

}

variable "subnet_public1" {
  type    = string
  default = "10.0.1.0/24"
}

variable "subnet_public2" {
  type    = string
  default = "10.0.10.0/24"
}

variable "subnet_private1" {
  type    = string
  default = "10.0.80.0/24"
}

variable "subnet_private2" {
  type    = string
  default = "10.0.5.0/24"
}

variable "ec2_ami" {
  type    = string
  default = "ami-052efd3df9dad4825"
}

variable "ec2_type" {
  type    = string
  default = "t2.micro"
}

variable "rds_password" {
  type      = string
  sensitive = true
  default   = "rizk123456"
}

variable "rds_username" {
  type      = string
  sensitive = true
  default   = "rizk"
}

variable "alb-name" {
  type      = string
  sensitive = true
  default   = "rizk"
}

