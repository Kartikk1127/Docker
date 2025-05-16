1. There are multiple issues that could occur while running docker swarm cluster on windows.
2. In order to make a cluster we need to have multiple VMs.
3. If you are thinking of using multipass, then let me tell you that windows has a very limited support for multipass.
4. Same goes for wsl2, very less support.
5. Now, if you have docker desktop we could have a workaround.
6. We know that we can also run docker in docker right?
7. That is what we are gonna do.
8. Execute : `docker network create --subnet=192.168.100.0/24 swarm-net`
9. Execute : `docker run -dit --name node1 --hostname node1 --network swarm-net --ip 192.168.100.2 --privileged docker:dind`
10. Execute : `docker run -dit --name node2 --hostname node2 --network swarm-net --ip 192.168.100.3 --privileged docker:dind`
11. Execute : `docker run -dit --name node3 --hostname node3 --network swarm-net --ip 192.168.100.4 --privileged docker:dind`
12. Now, open 3 powershell terminals and access all 3 containers.
13. Once, you enter the shell of container execute the below command on node1.
14. `docker swarm init --advertise-addr <ip>`
15. The token command you receive is what you execute on the other 2 nodes.
16. Execute: `docker swarm join --token <token> <ip>:2377`
17. Once all three nodes join in a cluster you are good to go.
18. Execute : `docker service create --name search --replicas 3 -p 9200:9200 elasticsearch:2`
19. Once elastic search container is up and running, now you have set up a swarm load balancer.
20. Everytime you do `curl <ip>:9200` , the request goes to any of the 3 nodes which basically means that all 3 nodes are running the task.