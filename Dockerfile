FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /home/app

COPY ./pom.xml /home/app/pom.xml
RUN mvn -f /home/app/pom.xml dependency:go-offline

COPY ./src /home/app/src
RUN mvn -f /home/app/pom.xml clean package -DskipTests

FROM eclipse-temurin:21-jdk AS runtime
EXPOSE 5000
WORKDIR /home/app
COPY --from=build /home/app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/home/app/app.jar"]