output "public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.k3s_vm.public_ip
}

output "ansible_inventory" {
  description = "Path to generated inventory file"
  value       = "${path.module}/../ansible/inventory.ini"
}

