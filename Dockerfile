# without multi stage docker build
FROM openjdk:17-jdk-alpine

WORKDIR /app

COPY src/Main.java /app/Main.java

RUN javac Main.java

CMD ["java","Main"]

#with multi stage docker build

# Stage 1: Build
# FROM openjdk:17-jdk-alpine AS build

# WORKDIR /app

# COPY src/Main.java .

# RUN javac Main.java

# Stage 2: Runtime
# FROM openjdk:17-jdk-alpine

# WORKDIR /app

# Only copy the compiled class file(s) to the runtime image
# COPY --from=build /app/Main.class .

# CMD ["java", "Main"]
