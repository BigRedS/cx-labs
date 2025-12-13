variable "region" {
  description = "AWS region"
  type        = string
}

variable "name_suffix" {
  type = string
  default = "-lab"
}

variable "user" {
  description = "Local username; used for tagging resources"
  type = string
}

variable "cx_team_name" {
  description = "CX team name; used for tagging resources"
  default = ""
  type = string
}

variable "thing_name" {
  description = "Name of the EC2 instance"
  type = string
}

variable "lab_type" {
  description = "Name of the project type"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "aws_ssh_key_name" {
  description = "Existing AWS keypair name"
  type        = string
}

variable "public_ssh_key_path" {
  description = "Path to your local SSH public key"
  type        = string
}

variable "private_ssh_key_path" {
  description = "Path to your local SSH private key (for passing to Ansible)"
  type        = string
}

variable "ec2_ami" {
  description = "id of AMI for EC2 VM. Should be a linux"
  type = string
}

variable "ec2_username" {
  description = "default login username for the AMI"
  type = string
  # 'admin' on debian, 'ubuntu' on ubuntu
  default = "admin"
}
