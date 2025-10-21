#!/bin/bash

vpc_id=$(aws ec2 describe-vpcs \
  --filters "Name=isDefault,Values=true" \
  --query "Vpcs[0].VpcId" \
  --output text)

if [[ "$vpc_id" == "None" || -z "$vpc_id" ]]; then
  echo "No default VPC found."
  exit 1
fi

subnet_ids=$(aws ec2 describe-subnets \
  --filters "Name=vpc-id,Values=$vpc_id" \
  --query "join(',', Subnets[].SubnetId)" \
  --output text)


export TF_VAR_vpc_id=$vpc_id
export TF_VAR_subnet_ids=$subnet_ids
