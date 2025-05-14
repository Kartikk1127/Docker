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
7. 