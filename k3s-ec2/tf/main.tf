resource "aws_key_pair" "bootstrap" {
  key_name   = "${var.aws_ssh_key_name}${var.name_suffix}"
  public_key = file(var.public_ssh_key_path)
}

resource "aws_security_group" "k3s_vm" {
  name        = "${var.thing_name}${var.name_suffix}"
  description = "Allow SSH and K3s traffic"
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh" {
  security_group_id = aws_security_group.k3s_vm.id
  ip_protocol = "tcp"
  to_port = "22"
  from_port = "22"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "allow_k8s_api" {
  security_group_id = aws_security_group.k3s_vm.id
  ip_protocol = "tcp"
  from_port = "6443"
  to_port = "6443"
  cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_out" {
  security_group_id = aws_security_group.k3s_vm.id
  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = -1
}

resource "aws_instance" "k3s_vm" {
  ami                    = var.ec2_ami
  instance_type          = var.instance_type
  key_name               = aws_key_pair.bootstrap.key_name
  vpc_security_group_ids = [aws_security_group.k3s_vm.id]

  tags = {
    Name = var.thing_name
  }

  root_block_device {
    volume_size = 50
    volume_type = "gp3"
    encrypted   = false
    delete_on_termination = true
  }

  provisioner "local-exec" {
    command = "echo '[k3s]\n${self.public_ip} ansible_user=${var.ec2_username} ansible_ssh_private_key_file=${var.private_ssh_key_path}' > ../ansible/inventory.ini"
  }
}
