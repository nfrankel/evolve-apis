FROM eclipse-temurin:17.0.6_10-jdk-alpine as build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN ./mvnw -B package

FROM eclipse-temurin:17.0.6_10-jre-alpine

COPY --from=build target/old-api-1.0.0.jar .

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "old-api-1.0.0.jar"]