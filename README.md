# Docker for Reposis
This dockerfile creates a simple mir within a tomcat.

Build parameters:

- MIR_VERSION - The MIR which will be downloaded from Sonatype default: 2018.06.0.3-SNAPSHOT

ENVIRONMENT Variables:

- APP_CONTEXT - the mir.war will be renamed to $APP_CONTEXT.war default: mir

Mount point

- /root/.mycore/context - see also $APP_CONTEXT

