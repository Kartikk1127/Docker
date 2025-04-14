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

### Building an image
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