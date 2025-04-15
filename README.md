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
4. Docker Client/Desktop : Connects the apis to help visualize all the docker containers in a UI. Helps in communicating with the docker engine.

## Installing Docker
1. You can download the docker desktop to run it locally on your machine
2. You can use the aws ec2 instance to run it on aws. 
3. Create an ec2 instance and follow along to run that instance inside your shell.
4. ```sudo apt-get install docker.io``` to download it on your aws instance -- This will give you access to docker engine, daemon and cli
5. Restrict permissions for your key: ```chmod 400 ~/<name of your instance key>.pem```
6. Connect to your instance using its public dns: ```ssh -i "<name of your instance key>.pem" ubuntu@<your dns>```
7. Try running ```docker ps```
8. If permission denied for the user, modify user using ```sudo usermod -aG docker $USER```
9. If the error persists, run ```newgrp docker```
10. Repeat step 5.

## Docker image
1. Think of an image like a small chit you carry to your exam center.
2. Using that chit you can write your whole answer sheet right?
3. So basically, in terms of docker the 'chit' is the 'docker image'.
4. And the answer copy you write becomes the 'docker container'
5. Just like the chit given to any person can help him/her pass exams, similarly using this docker image you can create containers anywhere and everywhere.
6. But, how to create a docker image? This is done by writing a **dockerfile**
7. In simple terms, an image is a blueprint that contains steps to run an application.
8. Dockerfile is a list of instructions that helps in creating an image.

### Building and Running an image
1. Create a dockerfile and list down all the instructions to build an image
2. Now, build an image
3. Run that image.
4. Is it necessary to write a dockerfile everytime to run a container?
5. Absolutely not, you can also run prebuilt images to run a container.
   1. ```docker pull hello-world``` will help you in pulling(downloading) an already existing image inside a docker hub(think of it like a shop for docker images)
   2. You should see something like: 
      1. ![img.png](img.png)
   3. Run ```docker images```.
   4. You should see something like: 
      1. ![img_1.png](img_1.png)
   5. Like this, without writing a dockerfile you were able to create an image.
   6. Next step is to run the image.
   7. Run ```docker run <image-name>```
   8. You should see something like: 
      1. ![img_2.png](img_2.png)
   9. You can also try running other images by pulling from dockerhub. Some examples include ```docker pull mysql```
   10. In order to run an image in [detached](#detached-mode) mode, the run command should look like ```docker run -d <image-name>```

**Note:** It's not necessary to build an image that already exists on docker hub. You can directly run the hello-world image by running ```docker run hello-world```.
          Docker will first pull the image from the dockerhub and then run the container. 
          You should see something like:
1. ![img_3.png](img_3.png)

### Detached Mode
When you run a container in detached mode, it does not block your screen. For instance below are the commands to run an image in 2 ways:

1. ```docker run hello-world``` : Runs without detached mode and hence opens up the log screen as soon as you run the command.
2. ```docker run -d hello-world``` : Gives you a container id which you can use to view the logs willingly whenever needed.

## Writing a Dockerfile
1. Before moving on to write a dockerfile, we need to understand that the image of our application should include the source code, the dependencies and the libraries used and everything related to the image.
2. This image becomes a box that includes everything related to the application and this is what becomes a container that runs for our application.
3. Now, building a custom image requires us to write a Dockerfile and here, writing a dockerfile involves a set of instructions to build a docker image.
4. Just like for you cooking Maggi involves a set of steps like getting a container -> boiling water -> putting maggi and masala -> cook. Finally you'll be having cooked maggi.
5. Similarly, by following a set of instructions in a dockerfile it'll help you in building an image of your application.

#### CMD VS ENTRYPOINT
The CMD and ENTRYPOINT commands serve different purposes and have distinct behaviors.

| CMD                                       |                ENTRYPOINT                 |
|:------------------------------------------|:-----------------------------------------:|
| sets default parameters for the container | sets primary parameters for the container |
| can be overridden                         |           cannot be overridden            |
| used for default parameters                         |           used for the main executable command            |

### Building a custom image
Run : ```docker build -t <image-name> .``` 
1. -t tag is used to provide an image name
2. **'.'** is used as a context. This means Docker will look for the Dockerfile in the current directory where the command is executed.

**Important**
Any code changes you make after creating a container will not be reflected inside the image and hence won't be visible when you run an old container or even restart/beat the shit out of it, it just won't work.
Hence, making code changes require you to build a new image(no command change) and then run that new image(no command change).

