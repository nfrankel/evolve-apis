FROM openjdk:17.0.2-slim-buster as build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN ./mvnw -B package

FROM openjdk:11-jre-slim-buster

COPY --from=build target/old-api-1.0.0.jar .

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "old-api-1.0.0.jar"]