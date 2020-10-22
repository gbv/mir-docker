# Docker for Reposis

This dockerfile creates a simple mir within a tomcat.

Build parameters:

- MIR_BRANCH - The branch which will be build default: 2019.06.x
- MIR_WAR_NAME - The war file which is the result of the build default: mir-2019.06.2-SNAPSHOT.war

ENVIRONMENT Variables:

- JDBC_NAME - The Username of the Database
- JDBC_PASSWORD - The Password of the User
- JDBC_DRIVER - The diver to use for JDBC
- JDBC_URL - The URL to use for JDBC
- APP_CONTEXT - The context of the webapp
- SOLR_URL - The url to the solr server
- SOLR_CORE - The name of the main solr core
- SOLR_CLASSIFICATION_CORE - The name of the classification solr core

Mount point

- /mcr/home/ - the mycore home directory
- /mcr/data/ - the mycore data directory

## build and deploy
```
sudo docker build --build-arg MIR_BRANCH=2020.06.x -t vzgreposis/mir:2020.06.x .
sudo docker push  vzgreposis/mir:2020.06.x
```
