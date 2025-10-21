#! /bin/bash

tfdir="$1"
verb="$2"
project="$3"

if which tofu > /dev/null; then
  tf=tofu
elif which terraform > /dev/null; then
  tf=terraform
else
  echo "> Neither 'tofu' nor 'terraform' found in \$PATH; install one of them and try again"
  exit 1
fi

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "No AWS credentials found, log in to AWS and copy-paste the Access keys"
  exit 1
fi

# Make all the CX_* vars into TF vars, lowercasing the name.
# Also the username, for labelling the artefacts
while read env_var; do
  export TF_VAR_$env_var
done <<< $(env | grep -e '^CX_' -e '^USER=' | awk -F= '{print tolower($1) "=" $2}')
# This will be the name of the keypair in AWS. We'll delete it on destroy anyway
export TF_VAR_aws_ssh_key_name=$USER

# Allow $USERNAME to override $USER so it's possible to set something custom.
if [ ! -z "$USERNAME"]; then
  echo "> Found USERNAME env var (set to '$USERNAME'); replacing USER (was '$USER')"
  USER=$USERNAME
fi

if [ -z "$USER" ]; then
  export TF_VAR_user="$(hostname -f)"
  echo "> Couldn't find a username configured. Using hostname ('$TF_VAR_user') instead"
else
  export TF_VAR_user=$USER
fi

export TF_VAR_aws_ssh_key_name=$TF_VAR_user
echo "> AWS SSH key name: $TF_VAR_aws_ssh_key_name"

export TF_VAR_lab_type="$project"

source ../common/get-default-vpc.sh
export TF_VAR_vpc_id=$TF_VAR_vpc_id
export TF_VAR_subnet_ids=$(echo '["'$TF_VAR_subnet_ids'"]' | sed 's/,/","/g')
echo "> VPC: $TF_VAR_vpc_id; Subnets: $TF_VAR_subnet_ids"

#TODO: Find the default ssh key better, surely I can ask SSH this?
if [ ! -z $AWS_SSH_PUBKEY ]; then
  export TF_VAR_public_ssh_key_path=$AWS_SSH_PUBKEY
  export TF_VAR_private_ssh_key_path=$AWS_SSH_PRIVKEY
elif [ -f ~/.ssh/id_rsa.pub ]; then
  export TF_VAR_public_ssh_key_path=~/.ssh/id_rsa.pub
  export TF_VAR_private_ssh_key_path=~/.ssh/id_rsa
elif [ -f ~/.ssh/id_ed25519.pub ]; then
  export TF_VAR_public_ssh_key_path=~/.ssh/id_ed25519.pub
  export TF_VAR_private_ssh_key_path=~/.ssh/id_ed25519
fi
echo "> Found SSH keypair: $TF_VAR_public_ssh_key_path and $TF_VAR_private_ssh_key_path"

# alphanumeric characters, underscores, hyphens, slashes, hash signs and dots are allowed
#if [ -z "CX_TEAM_NAME" ]; then
#  export TF_VAR_thing_name="${project}_${TF_VAR_user}"
#else
#  export TF_VAR_thing_name="${project}_${TF_VAR_user}_${CX_TEAM_NAME}"
#fi
export TF_VAR_thing_name="cs-tam-${TF_VAR_user}-$project"

echo "> cding to tfdir at $tfdir"
cd $tfdir

echo "> $tf ${verb}ing a thing called '$TF_VAR_thing_name', created by '$TF_VAR_user'"

if [[ "$verb" == "up" ]]; then
  $tf init --upgrade && $tf apply --auto-approve
elif [[ "$verb" == "plan" ]]; then
  $tf init --upgrade && $tf plan
elif [[ "$verb" == "down" ]]; then
  $tf init --upgrade && $tf destroy -auto-approve
else
  echo "Invalid verb '$verb'; should be one of 'up', 'plan' or 'down'"
  exit 1;
fi
