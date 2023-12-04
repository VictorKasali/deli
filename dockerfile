# Use maven:3.6.0-jdk-8-alpine as a parent image
FROM maven:3.6.0-jdk-8-alpine as build

# Set the working directory in the image to /app
WORKDIR /app

# Copy the pom.xml file to download dependencies
COPY pom.xml ./

# Download the dependencies
RUN mvn dependency:go-offline -B

# Copy your other files
COPY src ./src

# Build the project and package it as a war
RUN mvn package

# Use tomcat:8.0-jre8 as the final image
FROM tomcat:8.0-jre8

# Remove the default Tomcat applications
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the war file from the build stage
COPY --from=build /app/target/DeliApp.war /usr/local/tomcat/webapps/ROOT.war

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Run the Tomcat server
CMD ["catalina.sh", "run"]
