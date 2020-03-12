# Docker for Reposis

This dockerfile creates a simple mir within a tomcat.

Build parameters:

- MIR_BRANCH - The branch which will be build default: 2019.06.x
- MIR_WAR_NAME - The war file which is the result of the build default: mir-2019.06.2-SNAPSHOT.war

ENVIRONMENT Variables:

- APP_CONTEXT - the mir.war will be renamed to $APP_CONTEXT.war default: mir

Mount point

- /root/.mycore/context - see also $APP_CONTEXT

## build and deploy
```
sudo docker build --pull --no-cache . -t vzgreposis/mir:lts
sudo docker push  vzgreposis/mir:lts
```
