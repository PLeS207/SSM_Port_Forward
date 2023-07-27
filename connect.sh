#!/bin/bash
PATH=$PATH:"/c/Program Files/Amazon/SessionManagerPlugin/bin"

export AWS_PROFILE=dev
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:k8s.io/cluster-autoscaler/enabled,Values=true" --query "Reservations[*].Instances[*].InstanceId" --output text | head -1)
echo $INSTANCE_ID
ENDPOINT=$(aws rds describe-db-instances --query "DBInstances[?TagList[?Key=='Environment' && Value=='dev']].Endpoint.Address" --output text)
echo $ENDPOINT
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"1433\"],\"localPortNumber\":[\"1433\"],\"host\":[\"$ENDPOINT\"]}" &

export AWS_PROFILE=prod
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:k8s.io/cluster-autoscaler/enabled,Values=true" --query "Reservations[*].Instances[*].InstanceId" --output text | head -1)
echo $INSTANCE_ID
ENDPOINT=$(aws rds describe-db-instances --query "DBInstances[?TagList[?Key=='Environment' && Value=='prod']].Endpoint.Address" --output text)
echo $ENDPOINT
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"1433\"],\"localPortNumber\":[\"1434\"],\"host\":[\"$ENDPOINT\"]}" &
