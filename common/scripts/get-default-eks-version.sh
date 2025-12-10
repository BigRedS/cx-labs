eks_version=$(aws eks describe-cluster-versions \
  --default-only \
  --output text \
  --query "clusterVersions[?defaultVersion==\`true\`].clusterVersion")

export eks_version
