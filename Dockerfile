# Stage 1: Build the Java application
FROM maven:3-eclipse-temurin-25 AS build

WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn -B package -DskipTests
RUN mvn -B dependency:copy-dependencies -DoutputDirectory=target/dependency

# Stage 2: Create the container image
FROM eclipse-temurin:25-jre

WORKDIR /app

COPY --from=build /app/target/classes ./classes
COPY --from=build /app/target/dependency ./libs

CMD ["java", "-cp", "classes/*:libs/*", "Main"]