FROM ubuntu:latest
RUN apt-get update \
 && apt-get install -y apache2-utils \
 && rm -rf /var/lib/apt/lists/*
ENTRYPOINT ["ab","-n","1000","-c","10"]
CMD ["--help"]
