Dockerfile for test webapp image.
=========================

Execute following to get started:

```sh
docker build -t boilerplate    ../boilerplate
docker build -t psql_container ../psql

docker build -t webapp .
```

**1. Test connection with psql-server:**
```sh
docker rm pg_server # If error - OK.
docker run -d -P --name pg_server psql_container
docker run --rm -t -i --link pg_server:pg webapp bash
```
In container:
```sh
psql -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -d docker -U docker --password
# pass: docker
# in psql console: \l+
```

**2. Test nginx**
```sh
docker run --rm -p 80:80 webapp
```
Put host ip into browser and see how everything works well. You can get ip by executing following;
```sh
boot2docker ip
# or
echo $DOCKER_HOST
```