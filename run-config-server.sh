#!/bin/bash

docker container stop config-server
docker container rm config-server

docker run \
    --name config-server \
    --publish 8888:8888 \
    --volume /home/jpmorin/workspace/formation/spring-cloud-services/config-server-configs/dev:/config-server/config \
    steeltoeoss/config-server \
    --spring.profiles.active=native
    --spring.cloud.config.server.native.searchLocations=file:/config-server/config
