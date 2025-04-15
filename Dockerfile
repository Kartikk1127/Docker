#writing our first dockerfile

#pulling a base image so as to get all the required tools to run the application
#openjdk is the name of the image and after : lies the version of the image aka the tag of the image
FROM openjdk:17-jdk-alpine

#create a working directory where all the source code will be there. Basically, the container should have all the source code right? Hence we will create a working directory to copy all of that
WORKDIR /app

#now copy the whole code to this working directory
#This line copies all files from the current directory on the host machine to the /app directory in the Docker image.
COPY src/Main.java /app/Main.java

#once copied, we need to compile the source code right? Let's do that
#Important thing to note here is the below Main.java is the file residing inside your container and not your raw source code's Main
RUN javac Main.java

#Till now the container has been built, now you have to run the container right? Let's do that
CMD ["java","Main"]

#Note here, that without CMD the container will still be built but you won't be able to run it hence it is an important command.
#There's an alternative way for CMD which is known as ENTRYPOINT command, this can also be used to run the container. Please read the readme file to understand the difference.