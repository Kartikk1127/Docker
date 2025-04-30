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