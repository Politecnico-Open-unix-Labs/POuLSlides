# Docker
## Corsi GNU/Linux Avanzati 2016

-----

![](images/logo-poul.svg) <!-- .element: style="background: white; border-radius:10px" -->

https://slides.poul.org

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">
<img alt="Creative Commons License" style="border-width:0" src="images/cc-by-sa.png" /></a>

--

## What is Docker?
<br><br>
***"Docker allows you to package an application with all of its dependencies into a standardized unit [container] for software development."*** <!-- .element: class="fragment" data-fragment-index="1"-->

Note: 
Docker vi consente di pacchettizzare un'applicazione con tutte le sue dipendenze in un singolo contenitore.

--

## What is a containter?
A container is an environment where software runs.<br>
It can use only a specific set of resources (fs, net, etc.)
<br><br>
It's similar to a chroot, but much more powerful and flexible
<br><br>
A docker container **is not** a virtual machine

Note: 
Un container è un ambiente d'esecuzione.

Ha associate alcune risorse (fs, rete, ram, etc.) ed è isolato dal resto.

---

## And why should I use it?
It provides a consistent, reproducible environment to applications

<table class="table">
<thead><tr>
	<td>Advantages for Developers</td>
	<td>Advantages for Sysadmins</td>
</tr></thead>
<tbody>
<tr>
	<td>Easier development</td>
	<td>Isolation</td>
</tr>
<tr>
	<td>Easier testing</td>
	<td>Less dependency managment</td>
</tr>
</tr>
<tr>
	<td>Easier to document how to deploy</td>
	<td>Simplified mantainenance</td>
</tr>
</tbody>


Note: 
Docker consente di avere lo stesso ambiente in sviluppo, test e produzione

--

## Also
- Horizontal scaling
- One line deployment
- Cloud! 
- DevOps filosophy!

Note:
Solitamente associato a termini come:<br>
Scalare orizzontalmente<br>
Deployare in un comando<br>
Cloud<br>
DevOps

---

## Nice buzzwords there
# But what can it do?

--

# Docker crash course

--

## Install docker
Docker is available for GNU/Linux, Mac OSX and Windows

Instructions at https://docs.docker.com/engine/installation/

<small>If you run Ubuntu use Docker PPAs, the package in the repos is usually old</small>

Note: è possibile essere inseriti nel gruppo docker, ma comporta rischi (== ad essere sudoer)

--

## Hello world
```
# docker run alpine /bin/echo "Hello, World"
```

<pre><code data-trim>
Unable to find image 'alpine:latest' locally
latest: Pulling from library/alpine
d0ca440e8637: Pull complete 
Digest: sha256:a298c9e3d59d8607e7aeb90fab10b93a0c4dff68344163208f8c64af75257538
Status: Downloaded newer image for alpine:latest
Hello, World
</code></pre>

--

## What just happened?

```
# docker run alpine /bin/echo "Hello, World"
```
Docker has:

- Downloaded Alpine Linux image (a light GNU/Linux distro)
- Unpacked it
- Created a new container
- Run `echo "Hello, World"` inside the container

See https://docs.docker.com/engine/understanding-docker/ 
for more details.

--

## Interactive Hello World
Execute an interactive shell

```
# docker run -i -t alpine /bin/sh
```
```
/ # echo Hello, World!
Hello, World!
/ # exit
```

--

## Daemonized Hello World
Execute a container in background (-d option)

```
# docker run --name "hello_world" -d alpine \
	/bin/sh -c "while true; do echo hello world; sleep 1; done"
```
```
03b37fa08977fd01c8a95677b834473bfbc0fe82bd15982dee266935ad491a7e
```

--

## What's that?
Every container has a unique name and hash

To list existing containers execute

```
# docker ps -a
```

```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
03b37fa08977        alpine              "/bin/sh -c 'while tr"   9 seconds ago       Up 6 seconds                                    hello_world
1857ba99f339        alpine              "/bin/sh"                21 seconds ago      Exited (0) 18 seconds ago                       loving_fermi
a298c9e3d59d        alpine              "/bin/echo 'Hello, Wo"   37 seconds ago      Exited (0) 35 seconds ago                       hungry_meninsky
```

--

## Starting to get messy

Delete some containers
```
# docker rm <container_name_or_hash>
```

--

## Better
```
docker ps -a
```
```
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS                      PORTS               NAMES
03b37fa08977        alpine              "/bin/sh -c 'while tr"   3 minutes ago       Up 3 minutes                                    hello_world
```
The hello_world container is still running!
```
# docker stop hello_world
hello_world
# docker logs hello_world
Hello World
Hello World
Hello World
[...]
```

---

Ok, **enough Hello Worlds**
# I want to dockerize my own app <!-- .element: class="fragment" data-fragment-index="1"-->

--

# Here's how to do it

Let's say you have a node.js app, I'll use Up1:

https://github.com/Upload/Up1

It's a client-side encrypted file sharing service
<br><br>
We need to build an image

--

## Dockerfiles
Images are built using **Dockerfiles**

A Dockerfile contains a sequence of directives needed to build the image

Each directive will be executed in order

Note: 
Le immagini sono costruite usando Dockerfiles

I Dockerfiles contengono una sequenza di istruzioni necessarie per costruire l'immagine

--

### Example Dockerfile
```
FROM node:latest
MAINTAINER fcremo@users.github.com

EXPOSE 9000:9000

ENV HTTP="true" HTTP_LISTEN="0.0.0.0:9000" MAX_FILE_SIZE=50000000 [...]

RUN apt-get install -y git && cd /srv && \
	git clone https://github.com/Upload/Up1 && \
	cd Up1/server && npm install && apt-get remove -y git

WORKDIR /srv/Up1/server

COPY server.conf.template server.conf.template
COPY genconfig.sh genconfig.sh
COPY entrypoint.sh entrypoint.sh
COPY config.js.template ../client/config.js.template

RUN chmod +x genconfig.sh entrypoint.sh

ENTRYPOINT /srv/Up1/server/entrypoint.sh
```

--

## Build it
```
# git clone https://github.com/fcremo/Up1-docker.git
# cd Up1-docker
# docker build -t fcremo/up1 .
```
<br>
Builds the `up1` docker image
<br>
It's gonna take a couple of minutes..

--

## Meanwhile...
Useful commands:

| Command | Description |
|--|--|
| run | create and run a container |
| [re]start/stop/kill | [re]start/stop/kill a container |
| ps | list existing containers |
| images | list available images |
| build | build an image |
| rm/rmi | delete a container/image |
| rename | rename a container |

<br>
<br>
Google, `man` and `docker --help`<br>
are your friends

--

## Run it
```
# docker run -e "API_KEY=random1" -e "DELETE_KEY=random2" \
--name up1 -p 8080:9000 -v /tmp/up1:/srv/Up1/i/ -d \
fcremo/up1
```

<table class="small">
<thead><tr><td>Option</td><td>Meaning</td></tr></thead>
<tbody>
	<tr>
		<td>--name up1</td>
		<td>Set container name to up1</td>
	</tr>
	<tr>
		<td>-p 8080:9000</td>
		<td>Publish port 9000 on host port 8080</td>
	</tr>
	<tr>
		<td>-e "KEY=VAL"</td>
		<td>Set environment variable KEY to VAL</td>
	</tr>
	<tr>
		<td>-v /host/:/cont/</td>
		<td>Mount /host/ to /cont/</td>
	</tr>
</tbody>
</table>

Note: 
Ricordati di commentare sulle possibili variazioni delle opzioni (in particolare --volume)

--

By default ports are exposed only to the host machine

You can use `-p 0.0.0.0:8080:9000` to<br>
expose a port on the network

-----

Bonus: iptables kung-fu is applicable to docker<br>
*but not always reccomended*

--

## How does configuration work?

- When possible use environment variables

- Create configuration files on first run

- Usually done via templates
	- shell/sed/awk scripts <br>
	- https://github.com/jwilder/dockerize

- When env vars are not an option, mount configuration
	- e.g. docker run -v /host/config/:/container/config/

If you need to rebuild an image to change configuration you (**probably**) did something wrong

--

# DEMO
(how Up1-Docker configures up1 service)

--

## Golden Rules for Developers
Write apps that are

- modular
- configurable
- automatically upgradeable

Remember: containers are ephemeral - they could be replaced at any time

---

Ok, that was cool, but it was just a simple app
<br><br>
What about more complex setups?

--

# Mattermost
It's an open source chat app

And it requires a database to work

We'll use postgres

--

Containers for mattermost and postgres are already available on Docker Hub
<br><br>
```
# docker pull postgres
# docker pull jasl8r/mattermost
```
<br>
We want to make them talk to each other, <br>
while being isolated from the rest

--

## Create a network
```
# docker network create mattermost-net
```

--


## Run postgres

and attach the container to mattermost-net
```
# docker run --name mattermost-postgres -d \
--net mattermost-net \
--env 'POSTGRES_USER=mattermost' --env 'POSTGRES_PASSWORD=pwd' \
--volume /tmp/postgres:/var/lib/postgresql postgres
```

--

## Verify network configuration
See if mattermost-postgres is connected to the right network
```
# docker inspect mattermost-postgres | \
	jq ".[].NetworkSettings.Networks"
```
And check if it answers to pings
```
# docker run --rm --net mattermost-net alpine \
	/bin/ping -c 3 mattermost-postgres
```

--

Run mattermost

```
# docker run --name mattermost -d --publish 8080:80 \
	--net mattermost-net \
	--volume /tmp/mattermost:/opt/mattermost/data \
	--env 'DB_ADAPTER=postgres' \
	--env 'DB_HOST=mattermost-postgres' \
    --env 'DB_USER=mattermost' --env 'DB_PASS=pwd' \
    jasl8r/mattermost
```

--

Have you noticed?

Containers can talk to each other by name

## #itsmagic <!-- .element: class="fragment" data-fragment-index="1"-->

No, it's docker dns server resolving names of the containers <!-- .element: class="fragment" data-fragment-index="2"-->

---

No one wants to manually manage multiple containers
<br>
## Enter docker-compose <!-- .element: class="fragment" data-fragment-index="1"-->

Manage sets of containers using declarative files <!-- .element: class="fragment" data-fragment-index="1"-->

--

## Example
<a href="Mattermost/docker-compose.yml.txt" target="__blank">docker-compose.yml</a> for Mattermost

<!-- .txt extension to make sure the browser displays the file -->

--

## Deploy mattermost
<br>
Get docker-compose.yml
```
$ wget "https://raw.githubusercontent.com/jasl8r/docker-mattermost/master/docker-compose.yml"
```
execute
```
# docker-compose up
```
Done!

---

![](images/logo-poul.svg) <!-- .element: style="background: white; border-radius:10px" -->

https://slides.poul.org/

-----

Filippo Cremonese

<a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">
<img alt="Creative Commons License" style="border-width:0" src="images/cc-by-sa.png" /></a><br /><small>This work is licensed under <br><a rel="license" href="http://creativecommons.org/licenses/by-sa/4.0/">Creative Commons Attribution-ShareAlike <br>4.0 International License</a></small>
