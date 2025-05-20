1. `docker info` : Check if swarm is active or not.
2. `docker swarm init` : Activates swarm. You now have all the swarm features.
   1. Lots of PKI and security automation.
      1. Root signing certificate created for our swarm.
      2. Certificate is issued for first Manager node.
      3. Join tokens are created.
   2. Raft database created to store root CA, configs and secrets.
      1. Encrypted by default on disk.
      2. No need for another key/value system to hold orchestration/secrets.
      3. Replicates logs amongst Managers via mutual TLS in "control plane".
3. `docker node ls` : Lists down the nodes.
4. `docker service update --replicas (integer)` : Manages the number of replicas of the service.
5. `docker service ls` : Lists down the services.
6. `docker service rm <service name/id>` : Removes the services which in turn removes the containers associated with the service.
7. `docker node update --role manager <node name>` : Updates the node to the role of a manager.
8. `docker service create --replicas 3 alpine ping 8.8.8.8` : Creates a fully operational swarm cluster with 3 containers running inside a cluster.
9. `docker service create -p 8081:80 --name web nginx:1.13.7` : Just a create service command.
10. `docker service scale web=5` : Will spawn 5 tasks of the above service at runtime.
11. `docker service update --image nginx:1.13.6 web` : Will update the image of the above service at runtime.
12. `docker service update --publish-rm 8081 --publish-add 9090:80 web` : Using this you can change the port of the above service at runtime.
13. `docker service update --force <service name>` : Force updates a service.
14. `--health-cmd="pg_isready -U postgres || exit 1"` : Health command for postgres