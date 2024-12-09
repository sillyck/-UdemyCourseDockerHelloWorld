# Dockerfile Examples

## Docker commands
- docker build -t in28min/hello-world-docker:v1 .


## Dockerfile - 1 - Creating Docker Images

```
FROM openjdk:21-slim
COPY target/*.jar app.jar
EXPOSE 5000
ENTRYPOINT ["java","-jar","/app.jar"]
```

## Dockerfile - 2 - Build Jar File - Multi Stage
```
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /home/app
COPY . /home/app
RUN mvn -f /home/app/pom.xml clean package

FROM eclipse-temurin:21-jdk AS run
EXPOSE 5000
COPY --from=build /home/app/target/*.jar app.jar
ENTRYPOINT ["java","-jar","/app.jar"]

```

## Dockerfile - 3 - Caching

```
FROM maven:3.9.4-eclipse-temurin-21 AS build
WORKDIR /home/app

# Copiar sólo el pom.xml para descargar dependencias
COPY ./pom.xml /home/app/pom.xml
RUN mvn -f /home/app/pom.xml dependency:go-offline

# Ahora copiamos el resto del código
COPY ./src /home/app/src

# Compilar el proyecto
RUN mvn -f /home/app/pom.xml clean package -DskipTests

FROM eclipse-temurin:21-jdk AS runtime
EXPOSE 5000
WORKDIR /home/app
COPY --from=build /home/app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/home/app/app.jar"]

```
