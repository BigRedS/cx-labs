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

# Modern postgres wants /var/lib/postgresql/data to a subdir of a mountpoint and won't start otherwise
perl -pi -e 's@/var/lib/postgresql/data@/var/lib/postgresql@' ./tracey-reloaded/tracey-database/postgresql-deployment.yaml 

cp postgresql-pvc.yaml ./tracey-reloaded/tracey-database/postgresql-pvc.yaml

cd tracey-reloaded
chmod +x run-tracey.sh
./run-tracey.sh
