FROM eclipse-temurin:17.0.7_7-jdk-alpine as build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN ./mvnw -B package

FROM eclipse-temurin:17.0.7_7-jre-alpine

COPY --from=build target/new-api-2.0.0.jar .

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "new-api-2.0.0.jar"]