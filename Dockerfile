# Bind paths /root/.mycore/MIR/
FROM alpine/git as git
ARG MIR_BRANCH=master
RUN mkdir /opt/mir
WORKDIR /opt/
ADD https://api.github.com/repos/MyCoRe-Org/mir/git/refs/heads/$MIR_BRANCH mir-version.json
RUN git --version && \
    git clone https://github.com/MyCoRe-Org/mir.git
WORKDIR /opt/mir
RUN git checkout ${MIR_BRANCH}
FROM regreb/bibutils as bibutils
FROM maven:3-jdk-11 as maven
RUN groupadd maven && \
    useradd -m -g maven maven
USER maven
COPY --from=git --chown=maven:maven /opt/mir/ /opt/mir
WORKDIR /opt/mir
RUN mvn --version && \
    mvn clean install -Djetty -DskipTests && \
    rm -rf ~/.m2

FROM tomcat:9.0.35-jdk11
EXPOSE 8080
EXPOSE 8009

WORKDIR /usr/local/tomcat/
ARG PACKET_SIZE="65536"
ENV JAVA_OPTS="-Xmx1g -Xms1g"
ENV APP_CONTEXT="mir"
ENV MCR_CONFIG_DIR="/mcr/home/"
ENV MCR_DATA_DIR="/mcr/data/"
ENV XMX="1g"
ENV XMS="1g"
COPY --from=bibutils --chown=root:root /usr/local/bin/* /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/mir.sh
RUN ["chmod", "+x", "/usr/local/bin/mir.sh"]
RUN rm -rf /usr/local/tomcat/webapps/*
RUN mkdir /opt/mir/
RUN sed -ri "s/<\/Service>/<Connector protocol=\"AJP\/1.3\" packetSize=\"$PACKET_SIZE\" tomcatAuthentication=\"false\" scheme=\"https\" secretRequired=\"false\" allowedRequestAttributesPattern=\".*\" encodedSolidusHandling=\"decode\" address=\"0.0.0.0\" port=\"8009\" redirectPort=\"8443\" \/>&/g" /usr/local/tomcat/conf/server.xml
COPY --from=maven --chown=root:root /opt/mir/mir-webapp/target/mir-*.war /opt/mir/mir.war
COPY --from=maven --chown=root:root /opt/mir/mir-cli/target/mir-*.zip /opt/mir/mir.zip
RUN cd /opt/mir/ && unzip /opt/mir/mir.zip && /bin/sh -c "mv mir-cli-* mir"
CMD ["bash", "/usr/local/bin/mir.sh"]
