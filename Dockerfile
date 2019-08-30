# Bind paths /root/.mycore/MIR/
FROM tomcat:8-jre8
EXPOSE 8080
EXPOSE 8009
ARG MIR_VERSION=2018.06.0.3-SNAPSHOT
ARG PACKET_SIZE="65536"
#ARG PACKET_SIZE="8192"
ENV JAVA_OPTS="-Xmx1g -Xms1g"
ENV APP_CONTEXT="mir"
COPY docker-entrypoint.sh /usr/local/bin/mir.sh
RUN ["chmod", "+x", "/usr/local/bin/mir.sh"]
RUN rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/*
RUN curl "https://oss.sonatype.org/service/local/artifact/maven/content?r=snapshots&g=org.mycore.mir&a=mir-webapp&v=${MIR_VERSION}&e=war">webapps/mir.war
RUN cat /usr/local/tomcat/conf/server.xml | sed 's/"AJP\/1.3"/"AJP\/1.3" packetSize="${PACKET_SIZE}"/g' > /usr/local/tomcat/conf/server.xml.new
RUN mv /usr/local/tomcat/conf/server.xml.new /usr/local/tomcat/conf/server.xml
CMD ["/usr/local/bin/mir.sh"]