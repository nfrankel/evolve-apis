FROM eclipse-temurin:21-jdk-jammy AS build

COPY .mvn .mvn
COPY mvnw .
COPY pom.xml .
COPY src src

RUN ./mvnw -B package

FROM eclipse-temurin:21-jre-jammy

COPY --from=build target/new-api-2.0.0.jar .

EXPOSE 8082

ENTRYPOINT ["java", "-jar", "new-api-2.0.0.jar"]