# Bind paths /root/.mycore/MIR/
FROM tomcat:9-jre11
EXPOSE 8080
EXPOSE 8009
ARG mir_version=2018.06.0.2-SNAPSHOT
ARG PACKET_SIZE="65536"
#ARG PACKET_SIZE="8192"
ENV JAVA_OPTS="-Xmx1g -Xms1g"
RUN rm -rf /usr/local/tomcat/webapps/ROOT /usr/local/tomcat/webapps/ROOT.war
RUN curl "https://oss.sonatype.org/service/local/artifact/maven/content?r=snapshots&g=org.mycore.mir&a=mir-webapp&v=${mir_version}&e=war">webapps/mir.war
RUN cat /usr/local/tomcat/conf/server.xml | sed 's/"AJP\/1.3"/"AJP\/1.3" packetSize="${PACKET_SIZE}"/g' > /usr/local/tomcat/conf/server.xml
