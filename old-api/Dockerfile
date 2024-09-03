FROM eclipse-temurin:21.0.4_7-jdk-jammy AS build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN ./mvnw -B package

FROM eclipse-temurin:21.0.4_7-jre-jammy

COPY --from=build target/old-api-1.0.0.jar .

EXPOSE 8081

ENTRYPOINT ["java", "-jar", "old-api-1.0.0.jar"]