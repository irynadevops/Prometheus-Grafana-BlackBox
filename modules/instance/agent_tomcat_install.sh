#!/bin/bash

#-------------------------------#
# Installation of java  		#
#-------------------------------#

sudo yum install -y java-1.8.0-openjdk

#-------------------------------#
# Installation of tomcat  		#
#-------------------------------#

sudo yum install -y tomcat wget tomcat-admin-webapps tomcat-docs-webapp tomcat-javadoc tomcat-webapps
cd ~
## Upload and deploy sample.war for test
wget https://tomcat.apache.org/tomcat-7.0-doc/appdev/sample/sample.war 
sudo /bin/cp -rf sample.war /var/lib/tomcat/webapps/

## Change permissions
chown tomcat:tomcat -R /var/lib/tomcat/webapps/*
sudo chmod 775 -R /var/lib/tomcat/webapps/
sudo chmod 775 -R /usr/share/tomcat/logs/

## Change default login and password for tomcat (use login "tomcat" and password "tomcat")
sudo tee /usr/share/tomcat/conf/tomcat-users.xml << EOF
<?xml version="1.0" encoding="UTF-8"?>
<tomcat-users version="1.0" xmlns="http://tomcat.apache.org/xml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd">
  <role rolename="manager-gui"/>
  <role rolename="admin-gui"/>
  <role rolename="manager-script"/>
  <user username="tomcat" password="tomcat" roles="manager-gui,admin-gui,manager-script"/>
</tomcat-users>
EOF

## Enable and start servoces
sudo systemctl enable tomcat
sudo systemctl start tomcat

## Remove downloaded files
sudo rm -f sample.war

#-------------------------------#
# Installation of apache        #
#-------------------------------#
## Install httpd
sudo yum install -y httpd

## Make new permissions for httpd logs
sudo chmod 775 -R /var/log/httpd

## Eanble and start httpd
sudo systemctl enable httpd
sudo systemctl start httpd

sudo tee /usr/share/tomcat/lib/log4j.properties << EOF
log4j.rootLogger=CONSOLE,METRICS

log4j.appender.CONSOLE=org.apache.log4j.ConsoleAppender
log4j.appender.Threshold=DEBUG
log4j.appender.CONSOLE.Target=System.out
log4j.appender.CONSOLE.layout=org.apache.log4j.PatternLayout
log4j.appender.CONSOLE.layout.ConversionPattern=[%-5p][%d{yyyy-MM-dd HH\:mm\:ss,SSS}][%c] \:%m%n

log4j.appender.METRICS=io.prometheus.client.log4j.InstrumentedAppender
EOF

sudo systemctl restart tomcat httpd

## Disable SElinux and firewalld
sudo setenforce 0
sudo sed -i "s/SELINUX=.*$/SELINUX=disabled/" /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld

#-------------------------------------------#
# Installation of prometheus agent  		#
#-------------------------------------------#

## Install datadog agent
wget https://github.com/prometheus/node_exporter/releases/download/v1.0.1/node_exporter-1.0.1.linux-amd64.tar.gz
sudo tar xvfz node_exporter-1.0.1.linux-amd64.tar.gz
cd node_exporter-1.0.1.linux-amd64
sudo ./node_exporter &
