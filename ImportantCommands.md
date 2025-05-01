1. ```docker run -d --name mongo mongo``` : Will run the mongo db container with the name _mongo_ in the detached mode.
2. ```docker top mongo``` : Will list down the running processes running inside the mongo container started above.
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
11. 