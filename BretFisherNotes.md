# Image VS Container
1. An image is the application we want to run.
2. A container is an instance of that image running as a process.
3. You can have many containers running off the same image.
4. Docker's default image "registry" is called _Docker Hub_.

```docker container run --publish 80:80 nginx```
1. Downlaoded image 'nginx' from Docker hub.
2. Started a new container from that image.
3. Opened port 80 on the host IP.
4. Routes that traffic to the container IP, port 80.

**NOTE:** You'll get a _bind_ error if teh left number (host port) is being used by anything else, even another container. You can use any port you want on the left, like 8080:80 or 8888:80, then use localhost:8888 when testing.

**What happens in 'docker container run'?**
1. Looks for that image locally in image cache, doesn't find anything.
2. Then looks in remote image repository (defaults to Docker Hub).
3. Downloads the latest version (nginx:latest by default).
4. Creates new container beased on that image and prepares to start.
5. Gives it a vietual IP on a private network inside docker engine.
6. Opens up port 80 on host and forwards to port 80 in container.
7. Starts container by using the CMD in the image dockerfile.

**Case 1: Using -p <host_port>:<container_port>**
Example: **docker run -p 8080:8000 your_image**
_What happens_:
Your app inside the container must listen on port 8000.

Docker maps:
**localhost:8080 on your machine (host) → to 8000 inside the container**.

When you open localhost:8080, Docker forwards the request to your app.

**Important**:
1. If your app is instead hardcoded to run on 9000, this will not work.
2. You’ll get connection errors because nothing is listening on 8000 inside the container.


**Case 2: App runs on 9000, and you adjust the mapping**
Example: **docker run -p 8080:9000 your_image**
_What happens_:
Your app listens on port 9000 inside the container.

Docker maps:
**localhost:8080 (host) → 9000 (container).**
✅ This will work perfectly. Access localhost:8080 in browser or Postman.


**Case 3: Using --network host**
Example: **docker run --network host your_image**
_What happens_:
-> The container shares the host's network.
-> No port mapping is required.
-> If your app runs on 9000, you can directly access it via: localhost:9000
✅ Good for:
1. Linux environments (works natively).
2. No isolation needed.
3. Simpler setup during local testing.

**Important:**
1. Port conflicts: if port 9000 is already used on your host, the container will fail.
2. Reduced isolation — container behaves like it's part of your host system.

**Containers aren't Mini-VM's**
1. They are just processes.
2. Limited to what resources they can access.
3. Exit when process stops.

## Docker Networks Defaults
1. Each container connected to a private virtual network "bridge".
2. Each virtual network routes through NAT firewall on host IP.
3. All containers on a virtual network can talk to each other without -p.
4. Best practice is to create a new virtual network for each app:
   1. network "my_web_app" for mysql and php/apache containers.
   2. network "my_api" for mongo and nodejs containers.
5. Create your apps so frontend/backend sit on same docker network.
6. Their inter-communication never leaves host.
7. All externally exposed ports closed by default.
8. You must manually expose via -p, which is better default security.
9. This gets even better later with Swarm and Overlay networks.

## Docker Networks: How containers find each other?
1. DNS is the key to easy inter-container comms.
2. It works by default with custom networks.
3. Use ```--link``` to enable DNS on default bridge network.

### Static IP's and using IP's for talking to containers is an anti-pattern. Do your best to avoid it.
1. Docker daemon has a built-in DNS server that containers use by default.

## Container Images, Where to find them and how to build them?
1. All about images, the building blocks of containers.
2. [What's in an image (and what isn't)](#whats-in-an-image-and-what-isnt)
3. Using docker hub registry.
4. Managing out local image cache.
5. Building our own images.

### What's in an image (and what isn't)
1. App binaries and dependencies.
2. Metadata about the image data and how to run the image.
3. Official definition: "An image  is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime."
4. Not a complete OS. No kernel, kernel modules (eg: drivers)
5. Small as one file (your app binary) like a golang static binary.
6. Big as an Ubuntu distro with apt, and Apache, PHP, and more installed.
7. Alpine is just a distribution of an image that is very small.
8. Images are made up of file system changes and metadata.
9. Each layer is uniquely identified and only stored once on a host.
10. This saves storage space on host and transfer time on push/pull.
11. A container is just a single read/write layer on top of image.
12. docker image history and inspect commands can teach us.

### All about image tags and pushing them to docker hub
1. All about image tags.
2. How to upload to docker hub?
3. Image ID vs Tag.
4. **Things that change the least should be kept at the start of the dockerfile and the things that change the most should be kept at the bottom of the dockerfile.**

## Persistent Data: Volumes
1. Defining the problem of persistent data.
2. Key concepts with containers: immutable, ephemeral.
3. Learning and using Data volumes.
4. Learning and using Bind Mounts.
5. Assignments.

### Container lifetime and Persistent Data
1. Containers are usually immutable and ephemeral.
2. Immutable infrastructure: only re-deploy containers, never change.
3. This is the ideal scenario, but what about databases, or unique data?
4. Docker gives us features to ensure these separation of concerns.
5. This is known as "persistent data".
6. Two ways: Volume and Bind mounts
7. Volumes: make special location outside of container UFS.
8. Bind Mounts: link container path to host path.

### Bind Mounting
1. Maps a host file or directory to a container file or directory.
2. Basically just two locations pointing to the same file(s).
3. Again, skips UFS, and host files overwrite any in container.
4. Can't use in Dockerfile, must be at container run.
5. ... run -v /Users/bret/stuff:/path/container (mac/linux)
6. ... run -v //c/Users/bret/stuff:/path/container (windows).


## Dockerfile ENTRYPOINT

### Buildtime vs Runtime
One thing to note is the CMD command written in dockerfile is stored as metadata in the image store and is executed only when you run the container. It is not executed while building the image.
Thereby, CMD is a RUNTIME variable.  
Opposite to this, the WORKDIR, COPY, RUN are the commands that are used while image building and hence are BUILDTIME variable.  
To understand how dockerfiles affect the image and container, one should understand when different statements are used. Eg: Runtime statements don't affect the image build and are only image metadata until the container starts.  

| BUILDTIME:: docker build                          |             BOTH:: build and run             |                          RUNTIME:: docker run                           |
|:--------------------------------------------------|:--------------------------------------------:|:-----------------------------------------------------------------------:|
| FROM<br/>ADD<br/>COPY<br/>RUN<br/>ARG<br/>ONBUILD | LABEL<br/>ENV<br/>USER<br/>SHELL<br/>WORKDIR | EXPOSE<br/>VOLUME<br/>STOPSIGNAL<br/>CMD<br/>ENTRYPOINT<br/>HEALTHCHECK |

1. **Buildtime** statements affect the files in the image or how the image is built.
2. **Runtime** statements are typically stored as metadata and affect the container.
3. Some statements affect how the image is built and also change container start behaviour.
4. **Overwrite** statements replace any previous use.
5. **Additive** statements add to any previous use.
6. Know your base (FROM) images. Many statement types affect downstream images.
7. Understanding these effects helps troubleshoot Dockerfile and container issues.

_You can overwrite an Entrypoint using --entrypoint string. Eg:: ```docker run --entrypoint <command that overwrites> <container name>```_

### Takeaways
1. ENTRYPOINT executes a command on container start.
2. ENTRYPOINT is a RUNTIME statement, stored as metadata with an image.
3. Only the last ENTRYPOINT in a Dockerfile is used, making it an Overwrite type.
4. A container needs at least a CMD or an ENTRYPOINT to know hwo to start.
5. ENTRYPOINT requires more typing to overwrite compared to CMD, so it's rarely used by itself as a replacement for CMD.
6. You can overwrite ENTRYPOINT with ```docker run --entrypoint "something" <image>```

### Using ENTRYPOINT and CMD together
Located at: "src/docker/Dockerfile"  
**Basic Concepts** : Docker combines ENTRYPOINT and CMD into a single command when both are specified, enabling enhanced customization of container behavior.  
**Use Cases** :  
      1. Treating containers as command-line tools.  
      2. Running startup scripts before executing the main application.  
**Examples** :  
      1. A curl command example that demonstrates creating an image mimicking native curl behavior.  
      2. HTTPing utility is showcased to set preferred options and defaults.  
**Signal Handling and PID 1** :  
      1. Running a shell script as CMD can lead to signal handling issues which are crucial for graceful shutdowns.  
      2. Importance of having the main application as the first process in the container for receiving shutdown signals.  
**Using Exec in Scripts** :  
The use of the exec command in shell scripts is emphasized to ensure that the main application receives signals correctly.  

### Takeaways
1. If both ENTRYPOINT and CMD are set, they combine into a single command for starting the container.
2. For CLI tools, use ENTRYPOINT to set the base executable, while CMD should provide default arguments.
3. CMD can be easily overridden at docker run without replacing the ENTRYPOINT.
4. For pre-launch scripts, ENTRYPOINT should set the script, and CMD should set the final process.
5. ENTRYPOINT shell scripts should use exec "$@" to pass execution (PID 1) to the CMD.

### General Guidelines
1. RUN : Use Shell by default.
2. ENTRYPOINT : Always Exec, or CMD can't be used.
3. CMD : Use Exec by default, but sometimes shell form is needed for shell features.
4. ENTRYPOINT + CMD : Always use Exec to avoid weird edge cases.
5. Shell form will inject `/bin/sh -c` at the beginning of the command.
6. CMD statement can be preferred for starting long-lasting processes like web servers or databases.


## Docker Compose
1. Why: configure relationships between containers.
2. Why: save our docker container run settings in easy to read file.
3. Why: create one liner developer environment startups.
4. Comprised of 2 separate but related things
   1. YAML-formatted file that describes our solution options for:
      1. containers
      2. networks
      3. volumes
   2. A CLI tool docker-compose used for local dev/test automation with those YAML files.