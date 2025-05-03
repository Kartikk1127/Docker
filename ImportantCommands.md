1. ```docker run -d --name mongo mongo``` : Will run the mongo db container with the name _mongodb_ in the detached mode.
2. ```docker top mongo``` : Will list down the running processes running inside the mongodb container started above.
3. ```ps aux``` : Shows you all the running processes. You should be running this on a docker vm itself if using windows.
    1. First run : ```docker run -it --rm --privileged --pid=host justincormack/nsenter1```
    2. Then run : ```ps aux```
4.  ```docker container inspect``` : details of one container config like startup, config, volumes, networking etc.
5. ```docker container stats``` : performance stats for the containers like the memory and cpu usage.
6. ```docker container run -it``` : start new container interactively.
7. ```docker container exec -it``` : run additional command in existing container; starts an additional process.
8. _bash shell_ : if run with **-it**, it will give you a terminal inside the running container.
9. ```docker container -ai <container id>``` : **-ai** directs you inside the container terminal. This works when the container was earlier started with the interactive terminal.
10. ```docker container exec -it <container id>``` : Will give you access to the interactive terminal of the already running containers.
11. ```-p(--publish)``` : Publishing ports is always in **HOST:CONTAINER** format.
12. ```docker container port <container id>``` : Will show the port of the host and the container.
13. ```docker container inspect --format '{{ .NetworkSettings.IPAddress }}' <container id>``` : Will return the IP address of the container.
14. ```docker network connect <network id> <container id>``` : Attach a network to a container
15. ```docker network disconnect <network id> <container id>``` : Detach a network from a container.
16. ```--network bridge``` : Default Docker virtual network, which is NAT'ed behind teh host IP.
17. ```docker network inspect <network>``` : Lists the containers attached to the particular network.
18. ```--network host``` : It gains performance by skipping virtual networks but sacrifices security of container model. It attaches the container directly to the host interface.
19. 