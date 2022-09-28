# Start by building the application

FROM maven:3.8.6-openjdk-11 as builder
USER root
WORKDIR /home/app/
COPY . /home/app/
RUN mvn clean install -DskipTests=true

# Now copy it into our base image

FROM gcr.io/distroless/java11-debian11
WORKDIR /home/
COPY --from=builder /home/app/target/demo-0.0.1-SNAPSHOT.jar /home/
ENTRYPOINT [ "java", "-jar", "/home/demo-0.0.1-SNAPSHOT.jar", "--server.port=80" ] 


# Start by building the application

FROM maven:3.8.6-openjdk-11 as builder
USER root
WORKDIR /home/app/
COPY . /home/app/
ARG CONNECTION_STRING
#forthe RUN, if no live feature flag connection string is availiable, use -DskipTests=true
RUN mvn clean install -DAPP_CONFIGURATION_CONNECTION_STRING=$CONNECTION_STRING

# Now copy it into our base image

FROM gcr.io/distroless/java11-debian11
WORKDIR /home/
COPY --from=builder /home/app/target/demo-0.0.1-SNAPSHOT.jar /home/
ENTRYPOINT [ "java", "-jar", "/home/demo-0.0.1-SNAPSHOT.jar", "--server.port=80" ]