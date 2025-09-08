# Base image có sẵn Maven và JDK
FROM maven:3.8.6-openjdk-17 AS build


# Copy source code
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline -B
COPY src ./src


# Build project
RUN mvn clean package -DskipTests


# Stage run
FROM eclipse-temurin:17-jdk
WORKDIR /app

# Copy file .war từ stage build
COPY --from=build /app/target/ch06_ex1_email.war /app/app.war

# Expose port cho Render (Render sẽ map tự động)
EXPOSE 8080

# Start app
CMD ["java", "-jar", "/app/app.war"]
