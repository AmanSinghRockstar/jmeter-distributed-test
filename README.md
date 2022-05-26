# jmeter-distributed-test

Repo with a distributed setup for JMeter.

Based on the tutorial: https://www.vinsguru.com/jmeter-distributed-load-testing-using-docker/

## Prerequisites

1. Docker should be installed
2. Kubernetes should be setup / kubeconfig should be configured appropriately
3. Helm should be installed

## Contents

1. Docker files for JMeter base, master and slave.
2. Helm chart for JMeter cluster setup.
3. Batch scripts for cluster installation, JMX execution and cluster uninstallation.

## Cluster Deployment

These scripts create the JMeter master and slave pods on Kubernetes under the namespace: `jmeter`

To deploy the cluster, just run the following command:
```
./deploy-jmeter-master-slave.bat
```

The individual commands for various steps are listed below (just fyi, the previous batch file takes care of everything)
```
# Building base Docker image
docker build -t jmeter-base -f Dockerfile-base .

# Building master Docker image
docker build -t jmeter-master -f Dockerfile-master .

# Building server Docker image
docker build -t jmeter-server -f Dockerfile-server .

# Deploying jmeter-master-server using Helm chart
helm install jmeter-master-server jmeter-master-server --namespace jmeter --create-namespace
```

## JMX Execution

After the JMX file is ready, just copy the file to the `jmeter-jmx-files` folder, and then run the following batch file:
```
./run-jmeter-script.bat
```

The script will ask for the following things:

1. Name of the JMX file
2. Master pod name (for eg: `jmeter-master-server-master-54589b65d6-8pwnk`)
3. IP addresses of the desired SERVER pods (usually named as `jmeter-master-server-server-55b6c69556-j4kbl`) to be used for JMeter execution (IP addresses can be found with this command: `kubectl get pods -n jmeter -o wide`, already run as a part of the script) (for eg: `10.1.0.65,10.1.0.66`)

The commands executed as a part of the JMX execution (already a part of the batch file) are as follows:
```
# Fetching IP Addresses for the pods
kubectl get pods -n jmeter -o wide

# Copying the JMX file
kubectl cp -n jmeter ./jmeter-jmx-files/%JMETER_FILE_NAME% %MASTER_POD_NAME%:/tmp

# Executing the JMX file
kubectl exec -it -n jmeter %MASTER_POD_NAME% -- /bin/bash -c "jmeter -n -Jserver.rmi.ssl.disable=true -t /tmp/jmeter-jmx-files/%JMX_FILE_NAME% -l %JMX_FILE_NAME%_logs -R%SERVER_IPS%"
```

## Cluster Uninstallation

To uninstall the cluster, the following batch script can be used:
```
./uninstall-jmeter-master-slave-cluster.bat
```

The commands executed in this batch script are as follows:
```
# Removing JMeter cluster through Helm
helm uninstall jmeter-master-server --namespace jmeter
```