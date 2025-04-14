# Docker
What is docker?
Imagine you are a person who wants to ship some application to a client. You put in a lot of efforts to build that 
application and deployed it on your local machine. It works great. However, after shipping it to your client you get to 
know that the application didn't work on his/her machine. What would you do?

This is where docker comes in. It uses a docker engine to containerize your application. Basically, docker would create
a virtual environment for your application and build an image out of it. Now, you would ship that image to the client 
instead of your raw application. Now, the client could easily run your application since now he is running an image that
already has all the necessary dependencies required for your application to run.

## Docker Architecture
1. Docker Engine : Also known as docker application container engine on top of which all the docker containers run.
2. Docker Daemon : Or docker d is a service that manages your containers with shared memory. It also has a container d(a project written in Golang)
3. Docker CLI : Command Line Interface which helps to run all the docker related commands. Basically, all the commands you write in cli are pushed to docker d which in turn asks the container d to execute the specific operation.
4. Docker Client/Desktop : Connects the apis to help visualize all the docker containers in a UI.