FROM ubuntu

MAINTAINER Leonardo Soto, https://github.com/lsoton

RUN apt-get update -y && \
    apt-get install -y software-properties-common --no-install-recommends apt-utils && \
    apt-get install -y zip unzip curl lynx nano less  && \
    apt-get update -y

# Instalar Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer

# Define  directorio.
WORKDIR /data

# Define variable JAVA_HOME
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN apt-get update && apt-get install ca-certificates curl \
        gcc libc6-dev libssl-dev make \
        -y --no-install-recommends

#crear variable de  entorno tomcat

ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH
RUN mkdir -p "$CATALINA_HOME"
WORKDIR $CATALINA_HOME

#Descarga tomcat
ENV INCOMM_HOME /VARIABLE_ENV
ENV TOMCAT_MAJOR 7
ENV TOMCAT_VERSION 7.0.42
ENV TOMCAT_TGZ_URL https://archive.apache.org/dist/tomcat/tomcat-$TOMCAT_MAJOR/v$TOMCAT_VERSION/bin/apache-tomcat-$TOMCAT_VERSION.tar.gz

RUN set -x \
	&& curl -fSL "$TOMCAT_TGZ_URL" -o tomcat.tar.gz \
	&& tar -xvf tomcat.tar.gz --strip-components=1 \
	&& rm bin/*.bat \
	&& rm tomcat.tar.gz*

RUN cp $CATALINA_HOME/conf/tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.org.xml
RUN sed 's?.*/tomcat-users>.*?<role rolename="manager-gui"/>\n <role rolename="admin-gui"/> \n <user username="admin" password="admin" roles="admin-gui, manager-gui"/> \n\n&?' $CATALINA_HOME/conf/tomcat-users.xml > $CATALINA_HOME/conf/tomcat-users.new.xml
RUN mv $CATALINA_HOME/conf/tomcat-users.new.xml $CATALINA_HOME/conf/tomcat-users.xml


WORKDIR $CATALINA_HOME/bin

EXPOSE 8080 8443 80 443 22
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
