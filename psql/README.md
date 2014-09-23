Dockerfile for PSQL server image.
=========================

Execute following to get started:

```sh
docker build -t psql_container .
docker run -d -P --name pg_server psql_container

docker run --rm -t -i --link pg_server:pg psql_container bash
```
In container:
```sh
psql -h $PG_PORT_5432_TCP_ADDR -p $PG_PORT_5432_TCP_PORT -d docker -U docker --password
# pass: docker
# in psql console: \l+
```