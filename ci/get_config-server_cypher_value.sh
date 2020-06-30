#!/bin/bash

# arguments
config_server_uri=${1:?"[Argument Exception]: Missing CONFIG_SERVER_URI"}
value=${2:?"[Argument Exception]: Missing VALUE"}

# get bearer token
bearer_token=$(cf oauth-token)

# get decrypted config file
echo "POST ${config_server_uri}/encrypt" >&2
cipher=$(curl -k \
        -H "Authorization: ${bearer_token}" \
        -H 'Content-Type: text/plain' \
        -X POST "${config_server_uri}/encrypt" \
        --data-raw "${value}" \
        --silent)

echo "{cipher}${cipher}"
