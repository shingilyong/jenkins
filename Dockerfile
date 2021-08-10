[Dockerfile]
FROM aipcr.aip.samsungds.net/docker-registry/amazoncorretto:11.0.11
ARG GATEWAY_JAR=appGithub-0.0.1-SNAPSHOT.jar
COPY ${GATEWAY_JAR} appGithub.jar
ENTRYPOINT ["java", "-jar", "/appGithub.jar"]