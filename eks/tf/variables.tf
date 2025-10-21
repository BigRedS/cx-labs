variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "eks_k8s_version" {
  type = string
  default = "1.33"
}

variable "eks_node_type" {
  type = string
  default = "t3.medium"
}

variable "eks_min_nodes" {
  type = number
  default = 1
}

variable "eks_max_nodes" {
  type = number
  default = 3
}

variable "eks_desired_nodes" {
  type = number
  default = 2
}



variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-north-1"
}

variable "thing_name" {
  description = "Name of the EC1 Instance"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.large"
}

variable "aws_ssh_key_name" {
  description = "Existing AWS key name"
  type        = string
}

variable "public_ssh_key_path" {
  description = "Path to your local SSH public key"
  type        = string
}

variable "private_ssh_key_path" {
  description = "Path to your local SSH private key"
  type        = string
}

variable "ec2_ami" {
  description = "id of AMI for EC2 VM. Should be a linux"
  type = string
  # amd64 debian trixie
  default = "ami-0955d1e82085ce3e8"
}

variable "ec2_username" {
  description = "default login username for the AMI"
  type = string
  # 'admin' on debian, 'ubuntu' on ubuntu
  default = "admin"
}

variable "cx_team_name" {
  description = "Holds the team name, if known by the invoking script"
  type = string
  default = " "
}

variable "user" {
  description = "Local user running the terraform; used in the default tags"
  type = string
}
