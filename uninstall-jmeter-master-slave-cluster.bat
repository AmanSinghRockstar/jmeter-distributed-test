@echo off

echo Removing JMeter cluster through Helm
helm uninstall jmeter-master-server --namespace jmeter

set /p Var1="Script terminating..."