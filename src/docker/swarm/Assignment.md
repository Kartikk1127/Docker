## Create Multi-Service app
1. Use docker's distributed voting app.
2. Use `swarm-app-1` directory in our course repo for requirements.
3. 1 volume, 2 networks, and 5 services needed.
4. Create the commands needed, spin up services, and test app.
5. Everything is using Docker Hub images, so no data needed on Swarm.

### Answers
1. `docker network create --driver bridge --subnet=192.168.100.0/24`
2. `docker run -dit --name node1 --hostname node1 --network swarm-net -p 8081:8081 --ip 192.168.100.2 --privileged docker:dind`
3. `docker run -dit --name node2 --hostname node2 --network swarm-net --ip 192.168.100.3 --privileged docker:dind`
4. `docker run -dit --name node3 --hostname node3 --network swarm-net --ip 192.168.100.4 --privileged docker:dind`
5. On node1:
   1. `docker swarm init`
6. On node2:
   1. `docker swarm join --token <token>`
7. On node3:
   1. `docker swarm join --token <token>`
8. On node1:
   1. `docker node promote node2`
   2. `docker node promote node3`
9. On any node:
   1. `docker network create --driver overlay backend`
   2. `docker network create --driver overlay frontend`
   3. `docker service create --name db --network backend --replicas 1 --mount type=volume,source=db-data,target=/var/lib/postgresql/data -e POSTGRES_HOST_AUTH_METHOD=trust postgres:9.4`
   4. `docker service create --name redis --replicas 1 --network frontend redis:3.2`
   5. `docker service create --name worker --replicas 1 --network frontend --network backend bretfisher/examplevotingapp_worker`
   6. `docker service create --name vote --replicas 3 --network frontend -p 80:80 bretfisher/examplevotingapp_vote`
   7. `docker service create --name result --replicas 1 --network backend -p 5001:80 bretfisher/examplevotingapp_result`
   8. `apk update && apk add socat`
   9. `apk add curl`
   10. `socat TCP-LISTEN:8081,fork TCP:192.168.100.2:5001`