#!/bin/bash
set -e
FILE=/usr/local/tomcat/webapps/mir.war
if test -f "$FILE"; then
  echo "rename file to ${APP_CONTEXT}.war"
  mv /usr/local/tomcat/webapps/mir.war "/usr/local/tomcat/webapps/${APP_CONTEXT}.war"
  ls -la /usr/local/tomcat/webapps/
fi
catalina.sh run

