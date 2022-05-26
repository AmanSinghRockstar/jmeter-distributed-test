@echo off

echo Building base Docker image
docker build -t jmeter-base -f Dockerfile-base .

echo Building master Docker image
docker build -t jmeter-master -f Dockerfile-master .

echo Building server Docker image
docker build -t jmeter-server -f Dockerfile-server .

echo Deploying jmeter-master-server using Helm chart
helm install jmeter-master-server jmeter-master-server --namespace jmeter --create-namespace

set /p Var1="Script terminating..."