module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.0"

  cluster_name    = var.thing_name
  cluster_version = var.eks_k8s_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = false

  eks_managed_node_groups = {
    default = {
      instance_types = [var.eks_node_type]
      min_size       = var.eks_min_nodes
      max_size       = var.eks_max_nodes
      desired_size   = var.eks_desired_nodes
    }
  }
}

resource "null_resource" "write_kubeconfig" {
  depends_on = [module.eks]

  triggers = {
    cluster_name = module.eks.cluster_id
  }

  provisioner "local-exec" {
    command = <<EOT
aws eks update-kubeconfig --name ${module.eks.cluster_name} --region ${var.region} --kubeconfig ~/.kube/eks.yaml
echo "wrote kubeconfig to ${var.region} --kubeconfig ~/"

EOT
    interpreter = ["bash", "-c"]
  }
}
