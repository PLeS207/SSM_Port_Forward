#!/bin/bash
PATH=$PATH:"/c/Program Files/Amazon/SessionManagerPlugin/bin"

export AWS_PROFILE=reeco
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:k8s.io/cluster-autoscaler/enabled,Values=true" --query "Reservations[*].Instances[*].InstanceId" --output text | head -1)
echo $INSTANCE_ID
ENDPOINT=$(aws rds describe-db-instances --query "DBInstances[?TagList[?Key=='Environment' && Value=='dev']].Endpoint.Address" --output text)
echo $ENDPOINT
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"1433\"],\"localPortNumber\":[\"1433\"],\"host\":[\"$ENDPOINT\"]}" &
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"6379\"],\"localPortNumber\":[\"6379\"],\"host\":[\"master.dev-cluster.nog7rh.euc1.cache.amazonaws.com\"]}" &
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"9096\"],\"localPortNumber\":[\"9096\"],\"host\":[\"b-1.dev.v30wqb.c8.kafka.eu-central-1.amazonaws.com\"]}" &
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"22\"],\"localPortNumber\":[\"22\"],\"host\":[\"sftp-df.reeco.io\"]}" &

export AWS_PROFILE=reeco-prod
INSTANCE_ID=$(aws ec2 describe-instances --filters "Name=tag:k8s.io/cluster-autoscaler/enabled,Values=true" --query "Reservations[*].Instances[*].InstanceId" --output text | head -1)
echo $INSTANCE_ID
ENDPOINT=$(aws rds describe-db-instances --query "DBInstances[?TagList[?Key=='Environment' && Value=='prod']].Endpoint.Address" --output text)
echo $ENDPOINT
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"1433\"],\"localPortNumber\":[\"1434\"],\"host\":[\"$ENDPOINT\"]}" &
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"6379\"],\"localPortNumber\":[\"6380\"],\"host\":[\"master.prod-cluster.rb4dlk.use1.cache.amazonaws.com\"]}" &
aws ssm start-session --target $INSTANCE_ID --document-name AWS-StartPortForwardingSessionToRemoteHost --parameters "{\"portNumber\":[\"9096\"],\"localPortNumber\":[\"9097\"],\"host\":[\"b-2.prod.rmgdct.c3.kafka.us-east-1.amazonaws.com\"]}" &
