FROM eclipse-temurin:21-jdk

WORKDIR /app

COPY HelloWorld.java .

# compile the java file during the build
RUN javac HelloWorld.java

EXPOSE 8080

CMD ["java", "HelloWorld"]
