FROM eclipse-temurin:17-jdk-alpine as build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN ./mvnw -B package

FROM eclipse-temurin:17-jre-alpine

COPY --from=build target/old-api-1.0.0.jar .

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "old-api-1.0.0.jar"]