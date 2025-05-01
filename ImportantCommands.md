1. **docker run -d --name mongo mongo** : Will run the mongo db container with the name _mongo_ in the detached mode.
2. **docker top mongo** : Will list down the running processes running inside the mongo container started above.
3. **ps aux** : Shows you all the running processes. You should be running this on a docker vm itself if using windows.
    1. First run : **docker run -it --rm --privileged --pid=host justincormack/nsenter1**
    2. Then run : **ps aux**
4.    