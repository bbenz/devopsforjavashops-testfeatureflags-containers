# Start by building the application
FROM maven:3.8.6-openjdk-11 as builder
USER root
WORKDIR /home/app/
COPY . /home/app/
#ENV APP_CONFIGURATION_CONNECTION_STRING Endpoint=${ENDPOINT};Id=${ID};Secret=${SECRET}'
ENV APP_CONFIGURATION_CONNECTION_STRING "${APP_CONFIGURATION_CONNECTION_STRING}"
RUN mvn clean install

# Now copy it into our base image
FROM gcr.io/distroless/java11-debian11
WORKDIR /home/
COPY --from=builder /home/app/target/demo-0.0.1-SNAPSHOT.jar /home/
ENV APP_CONFIGURATION_CONNECTION_STRING "${APP_CONFIGURATION_CONNECTION_STRING}"
ENTRYPOINT [ "java", "-jar", "/home/demo-0.0.1-SNAPSHOT.jar", "--server.port=80" ]
