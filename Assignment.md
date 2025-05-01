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