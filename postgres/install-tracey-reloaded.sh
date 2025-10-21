#! /bin/bash

if which tofu > /dev/null; then
  tf=tofu
elif which terraform > /dev/null; then
  tf=terraform
else
  echo "> Neither 'tofu' nor 'terraform' found in \$PATH; install one of them and try again"
  exit 1
fi

if [ -d tracey-reloaded ]; then
  echo "+ tracey-reloaded already checked out; updating"
  cd tracey-reloaded
  mv .git.bak .git
  git pull
  mv .git .git.bak
  cd ..
else
  echo "+ git cloning tracey-reloaded"
  git clone https://github.com/georgep1ckers/tracey-reloaded.git
  mv tracey-reloaded/.git tracey-reloaded/.git.bak
fi

vol_id=$(cd tf ; $tf output postgres_ebs_volume_id | sed 's/"//g')

echo $vol_id

cat <<EOD > ./tracey-reloaded/pv-deployment.yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: postgresql-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: gp2
  awsElasticBlockStore:
    volumeID: $vol_id
    fsType: ext4
  claimRef:
    namespace: default
    name: postgresql-pvc
EOD

cd tracey-reloaded

kubectl apply -f ./pv-deployment.yaml
chmod +x run-tracey.sh
./run-tracey.sh
