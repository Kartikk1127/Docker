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
6. This is stateless load balancing.
7. This LB is at OSI layer 3 (TCP), not layer 4 (DNS).
8. Both limitation can be overcome with:
   1. Nginx or HAProxy LB
   2. Docker Enterprise Edition, which comes with built-in L4 web proxy.
9. The overlay network driver is used for container communication across a swarm.
10. Containers and networks are many-to-many relationship. A single container can be attached to many networks.
11. There is a load balancer in the overlay networking driver, and will distribute the incoming network connections automatically for you.
12. Overlay network is the only network we could use in a swarm because overlay allows us to span across nodes, as if they're all on the local network.

## Stacks: Production Grade Compose
1. In 1.13 Docker adds a new layer of abstraction to Swarm called Stacks.
2. Stacks accept Compose files as their declarative definition for services, networks, and volumes.
3. We use `docker stack deploy` rather than docker service create.
4. Stacks manages all those objects for us, including overlay network per stack. Adds stack name to start of their name.
5. New `deploy`: key in Compose file. Can't do `build`.
6. Compose now ignores `deploy:`, Swarm ignores `build:`
7. `docker-compose` cli not needed on Swarm server.

## Secrets Storage
1. Easiest "secure" solution for storing secrets in Swarm.
2. What is a secret?
   1. Usernames and passwords.
   2. TLS certificates and keys.
   3. SSH keys
   4. Any data you would prefer not be "on front page of news".
3. Supports generic strings or binary content up to 500Kb in size.
4. Doesn't require apps to be rewritten.
5. As of Docker 1.13.0 Swarm Raft DB is encrypted on disk.
6. Only stored on disk on Manager nodes.
7. Default is Managers and Workers "control plane" is TLS+Mutual Auth.
8. Secrets are first stored in Swarm, then assigned to a service.
9. Only containers in assigned Service can see them.
10. They look like files in container but are actually in-memory fs
    1. /run/secrets/<secret_name> or
    2. /run/secrets/<secret_alias>
11. Local docker-compose can use file-based secrets, but not secure.

## Service Updates
1. Provides rolling replacement of tasks/containers in a service.
2. Limits downtime(be careful with "prevents" downtime).
3. Will replace containers for most changes.
4. Has many, many cli options to control the update.
5. Create options will usually change, adding -add or -rm to them.
6. Includes rollback and healthcheck options.
7. Also has scale and rollback subcommand for quicker access.
   1. `docker service scale web=4` and `docker service rollback web`
8. A stack deploy, when pre-existing, will issue service updates.

### Swarm update examples
1. Just update the image used to a newer version.
   1. `docekr service update --image myapp:1.2.1 <servicename>`
2. Adding an environment variable and remove a port.
   1. `docker service update --env-add NODE_ENV=production --publish-rm 8080`
3. Change number of replicas of two services.
   1. `docker service scale web=8 api=6`

## Docker HealthChecks
1. HEALTHCHECK was added in 1.12.
2. Supported in Dockerfile, Compose YAML, docker run, and Swarm Services.
3. Docker engine will exec's the command in the container(eg: curl localhost).
4. It expects exit 0(OK) or exit 1(Error).
5. Three container states: _starting, healthy, unhealthy_.
6. Much better than "is binary still running?"
7. Not an external monitoring replacement.
8. Healthcheck status shows up in `docker container ls`.
9. Check last 5 healthchecks with `docker container inspect`.
10. Docker run does nothing with healthchecks.
11. Services will replace tasks if they fail healthcheck.
12. Services updates wait for them before continuing.