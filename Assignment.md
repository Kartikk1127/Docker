1. docs.docker.com and --help are your friend.
2. Run a nginx, a mysql and a httpd (apache) server
3. Run all of them in detached mode and with name.
4. nginx should listen on 80:80, httpd on 8080:80, mysql 3306:3306
5. When running mysql, use the --env or -e to pass the MYSQL_RANDOM_ROOT_PASSWORD=yes
6. Use docker container logs on mysql to find the random password it created on startup.
7. Clean it all up with docker container stop and docker container rm (both can accept multiple names or ID's).
8. Use docker container ls to ensure everything is correct before and after cleanup.


### Answers
1. Apache : ```docker run -d -p 8080:80 --name httpd httpd```
2. Mysql : ```docker run -d -e MYSQL_ROOT_PASSWORD=root --name mysql mysql```
3. Nginx : ```docker run -d -p 80:80 --name nginx nginx```


## Assignment 2
1. Dockerfiles are part process workflow and part art.
2. Take existing Node.js app and dockerize it.
3. Make dockerfile. Build it. Test it. Push it. Rm it. Run it.
4. Expect this to be iterative.
5. Details in dockerfile-assignment-1/Dockerfile.
6. Use the alpine version of the official 'node' 6.x image.
7. Expected result is website at http://localhost
8. Tag and push to your docker hub account.
9. Remove your image from local cache, run again from hub.


## Assignment 3
1. Database upgrade with containers.
2. Create a postgres container with named volume psql-data using version 9.6.1
3. Use Docker hub to learn VOLUME path and versions needed to run it.
4. Check logs, stop container
5. Create a new postgres container with same named volume using 9.6.2
6. Check logs to validate.
7. Note: This only works with patch versions, most SQL DB's require manual commands to upgrade DB's to major/minor versions, i/e/ it's a DB limitation not a container one.

### Answers
1. ```docker volume create pgdata```
2. ```docker container run -d --name postgres -e POSTGRES_HOST_AUTH_METHOD=trust -v pgdata:/var/lib/postgresql/data postgres:15.1```
3. ```docker container run -d --name postgres2 -e POSTGRES_HOST_AUTH_METHOD=trust -v pgdata:/var/lib/postgresql/data postgres:15.2```


## Assignment 4
1. Use a Jekyll "Static Site Generator" to start a local web server.
2. Don't have to be web developer: this is example of bridging the gap between local file access and apps running in containers.
3. source code is in the course repo under bindmount-sample-1
4. We edit files with editor on our host files and updates web server
5. start container with ```docker run -p 80:4000 -v $(pwd):/site bretfisher/jekyll-serve```
6. Refresh our browser to see changes.
7. Change the file in _posts\ and refresh browser to see changes.

## Assignment 5 : Answers :
src/docker/entrypoint/Dockerfile
1. `docker build -t cmatrix .`
2. `docker container run -it cmatrix sh`