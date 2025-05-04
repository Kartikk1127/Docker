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

## What's in an image (and what isn't)
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