FROM openjdk:8-jdk-slim AS build

WORKDIR /app

COPY ./TMillis.java /app

RUN javac TMillis.java \
&&  jar cfe demo.jar TMillis TMillis.class

FROM solutionsoft/time-machine-for-distroless-java8:latest

ENV  CLASSPATH=/app

WORKDIR /app

COPY --from=build /app/demo.jar /app

CMD ["demo.jar"]
