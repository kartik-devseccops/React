#!/bin/bash

echo "Generating .env with param $ENVIRONMENT for service $SERVICE_NAME"

aws ssm get-parameters-by-path --path "/$ENVIRONMENT/$SERVICE_NAME/" --with-decryption \
  --region ap-south-1 --query="Parameters[*].[Name, Value]" \
  --output text |
 while read line
 do
    name=$(echo ${line} | cut -f 1 -d ' ' | sed -e "s/\/$ENVIRONMENT\/$SERVICE_NAME\///g")
    value=$(echo ${line} | cut -f 2 -d ' ')
    echo "${name}=${value}" >> .env
 done
ls -lart
cat .env

source .env
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY

aws s3 ls
aws eks update-kubeconfig --region ap-south-1 --name $CLUSTER_NAME

echo $env/$organisation

cd config

aws ssm get-parameters-by-path --path "/$ENVIRONMENT/$SERVICE_NAME/config" --with-decryption \
  --region ap-south-1 --query="Parameters[*].[Name, Value]" \
  --output text |
 while read line
 do
    name=$(echo ${line} | cut -f 1 -d ' ' | sed -e "s/\/$ENVIRONMENT\/$SERVICE_NAME\/config\///g")
    if [ $name == "GMAIL_PASS" ]; then
      value=$(echo ${line} | cut -d' ' -f2-)
    else
      value=$(echo ${line} | cut -f 2 -d ' ')
    fi
    echo "${name}=${value}" >> config.env
 done
ls -lart
cat config.env

PORT=3000 DEBUG=myapp:* npm start

