[Dockerfile]
FROM java:8
ARG GATEWAY_JAR=build/libs/appGithub-0.0.1-SNAPSHOT.jar
COPY ${GATEWAY_JAR} appGithub.jar
ENTRYPOINT ["java", "-jar", "/appGithub.jar"]