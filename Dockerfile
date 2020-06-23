# Bind paths /root/.mycore/MIR/
FROM alpine/git as git
ARG MIR_BRANCH=master
RUN mkdir /opt/mir
WORKDIR /opt/
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

FROM tomcat:9.0.35-jre11
EXPOSE 8080
EXPOSE 8009
USER root
WORKDIR /usr/local/tomcat/
ARG PACKET_SIZE="65536"
ENV JAVA_OPTS="-Xmx1g -Xms1g"
ENV APP_CONTEXT="mir"
COPY --from=bibutils --chown=root:root /usr/local/bin/* /usr/local/bin/
COPY docker-entrypoint.sh /usr/local/bin/mir.sh
RUN ["chmod", "+x", "/usr/local/bin/mir.sh"]
RUN rm -rf /usr/local/tomcat/webapps/*
RUN cat /usr/local/tomcat/conf/server.xml | sed "s/\"AJP\/1.3\"/\"AJP\/1.3\" packetSize=\"$PACKET_SIZE\" tomcatAuthentication=\"false\" scheme=\"https\" secretRequired=\"false\" encodedSolidusHandling=\"passthrough\" /g"> /usr/local/tomcat/conf/server.xml.new
RUN mv /usr/local/tomcat/conf/server.xml.new /usr/local/tomcat/conf/server.xml
COPY --from=maven --chown=root:root /opt/mir/mir-webapp/target/mir-*.war /usr/local/tomcat/webapps/mir.war
CMD ["/usr/local/bin/mir.sh"]
