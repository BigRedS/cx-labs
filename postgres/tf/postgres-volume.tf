resource "aws_ebs_volume" "postgres_data" {
  availability_zone = aws_instance.k3s_vm.availability_zone
  size              = 1
  type              = "gp2"

  tags = {
    Name = "${var.thing_name}-postgres-data"
  }
}
