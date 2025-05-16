## Containers Everywhere = New Problems
1. How do we automate container lifecycle?
2. How can we easily scale out/in/up/down?
3. How can we ensure our containers are re-created if they fail?
4. How can we replace containers without downtime (blue/green deploy)?
5. How can we control/track where containers get started?
6. How can we create cross-node virtual networks?
7. How can we ensure only trusted servers run our containers?
8. How can we store secrets, keys, passwords and get them to the right container (and only that container)?

## Swarm Mode: Built in Orchestration
1. Swarm mode is a clustering solution built inside docker.
2. Not enabled by default, new commands once enabled:
   1. docker swarm
   2. docker node
   3. docker service
   4. docker stack
   5. docker secret
3. The goal of the orchestrator is to match the numbers (x/n) where x is the number of services actually running and n is the number that needs to be achieved.
4. The goal of the Swarm service is that it's able to replace containers and update changes in the service without taking the entire service down.
5. If you had a service with 3 containers running in it, you could technically take down one at a time to make a change and do sort of a rolling update, which is the blue-green pattern.
6. With a service having 3 containers running, if any of them goes down due to any reason, the service will automatically bring a new container up and running.

## Overlay Multi-Host Networking
1. Just choose `--driver overlay` when creating network.
2. For container-to-container traffic inside a single Swarm.
3. Optional IPSec (AES) encryption on network creation.
4. Each service can be connected to multiple networks(eg: frontend, backend)

**Exercise:** After creating a 3 node cluster, run the following commands on any of the one nodes. You'll see a proper routing happening on all the nodes.
1. `docker network create --driver overlay mydrupal`
2. `docker service create --name psql --network mydrupal -r POSTGRES_PASSWORD=root postgres:14`
3. `docker service create --name drupal -p 80:80 --network mydrupal drupal:9`

## Creating a 3 node cluster.
1. Open play-with-docker and start 3 instances OR  Use multipass.
2. Run `docker swarm init` on node1.
3. Run `docker swarm --join token <token>` on other nodes so they join the node1.
4. node1 should be the **leader**
5. node2 and node3 should be **manager**. If they are not, update their roles by executing `docker node update --role manager <node2/node3>`
6. Now all nodes have joined a single swarm cluster.
7. Now, whatever images you run(for instance you run a frontend and a backend service which should be connected), they will run inside a single cluster and hence a proper working system starts.

## Scaling out with Routing Mesh
1. Routes ingress(incoming) packets for a service to proper task.
2. Spans all nodes in swarm.
3. Uses IPVS from linux kernel.
4. Load balances swarm services across their tasks.
5. It works two ways:
   1. Container to container in an Overlay network.(Uses VIP)
   2. External traffic incoming to published ports.(all nodes listen)