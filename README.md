Configuracion tomcat 7 com Oracle JDK 8, con ubuntu 16.04.
crear el docker
# docker build -t lsoton/ubuntu-tomcat7-jdk8 .

Para configurar utilizar el comando DockerCompose.yml.

# docker-compose -f DockerCompose.yml up -d

para crear el contenedor.

La imagen esta disponible DockerHub https://hub.docker.com/r/lsoton/ubuntu-tomcat7-jdk8
