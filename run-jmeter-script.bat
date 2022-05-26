@echo off

echo Available JMX Files (in jmeter-jmx-files folder): 
dir jmeter-jmx-files

set /p JMX_FILE_NAME="Please enter the file name for the JMX file to be executed: "

echo Fetching IP Addresses for the pods
kubectl get pods -n jmeter -o wide

set /p MASTER_POD_NAME="Please enter the name of the master pod: "

set /p SERVER_IPS="Please enter comma-separated list (without spaces) of the desired server IP addresses: "

echo Copying the JMX file
kubectl cp -n jmeter ./jmeter-jmx-files/%JMETER_FILE_NAME% %MASTER_POD_NAME%:/tmp

echo Executing the JMX file
kubectl exec -it -n jmeter %MASTER_POD_NAME% -- /bin/bash -c "jmeter -n -Jserver.rmi.ssl.disable=true -t /tmp/jmeter-jmx-files/%JMX_FILE_NAME% -l %JMX_FILE_NAME%_logs -R%SERVER_IPS%"

set /p Var1="Script terminating..."