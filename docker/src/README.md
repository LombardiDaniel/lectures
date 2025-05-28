# Docker & Linux Containers

Daniel Lombardi | 2025-05-28 | [slides](/docker/keynote.pdf)

Check out [patos.dev](https://patos.dev)!

## Why Containers?

When developing applications, we commonly have a larger stack that needs many programs
working together to make our app work. Such as a Load Balancer, Databases, Queues and
Caches. Each of those programs needs their own libraries and other dependencies. Very
quickly we reach the matrix hell.

As such, we need some form of isolation. This could be done with VMs, but they add
unecessary overhead. Containers are the solution!

## Containers

Containers are Isolated Environments (that allow us to utilize the hosts Kernel).
By their design, they are extreemely portable, simple and lightweight. Containers
are used both in development as in produciton and have a really active community.
There are also alternatives to docker, like podman wich does not use a deamon and
allows us to run rootless containers.

By creating such isolated envs, orchestration services such as Kubernetes use this
to allow the container to fail without impacting other services in the host. If a
process fails, let it die.

### Containers vs. VMs

Containers allow very simple abstraction to isolated environments. VMs normally have
much more competing resources as there needs to run a Hypervisor and each VM's guest
operating system, when in reality we dont even need all that virtualization. This also
simplifies the networking and filesystem integration, allowing us to still use parts of
(or all) systems from the host, such as specific networking ports or protocols and
directories.

So, what does this mean? It means that even though we have such an isolated environment,
we can still easily save our database in our host file-system (so it's no longer ephermeral
storage). We can also access the hosts network, or create seperate networks for our app,
making the database protected from external acces, being only visible to our app's internal
network.

## Docker

Docker has 3 main concepts:

- Dockerfile
- Image
- Container

Dockerfile is just code that tells docker how to build an image, it specifies dependencies
down to the Operating System level. Starting from a `FROM` clause, specifying the base image
from docker.

The `docker build` command goes through all the steps in the Dockerfile and executes them.
It creates a multiple layer (allows caching) image that is immutable and can be passed to
other docker hosts.

The `docker run` command executes the `CMD` clause in the Dockerfile inside the specified
image, creating a running container.

## Hands-On

Docker Hello World

```sh
curl -fsSL https://get.docker.com/ | sh && sudo usermod -aG docker $USER
docker run -ti debian /bin/bash
```

Check out [src/docker-compose.yml](/docker/src/docker-compose.yml).
