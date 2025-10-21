output "cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_ca_certificate" {
  description = "EKS cluster CA certificate (base64 encoded)"
  value       = module.eks.cluster_certificate_authority_data
}

output "aws_iam_authenticator_command" {
  description = "Command to generate a token for kubectl"
  value       = "aws eks get-token --cluster-name ${module.eks.cluster_name} --region ${var.region}"
}

output "kubeconfig_yaml" {
  description = "Kubeconfig YAML snippet for this cluster"
  value = <<EOD
apiVersion: v1
kind: Config
clusters:
- cluster:
    server: ${module.eks.cluster_endpoint}
    certificate-authority-data: ${module.eks.cluster_certificate_authority_data}
  name: ${module.eks.cluster_name}
contexts:
- context:
    cluster: ${module.eks.cluster_name}
    user: aws
  name: ${module.eks.cluster_name}
current-context: ${module.eks.cluster_name}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      command: aws
      args:
        - eks
        - get-token
        - --region
        - ${var.region}
        - --cluster-name
        - ${module.eks.cluster_name}
EOD
}
