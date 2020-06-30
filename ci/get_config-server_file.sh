#!/bin/bash

# arguments
service_name=${1:?"[Argument Exception]: Missing SERVICE_NAME"}
config_name=${2:?"[Argument Exception]: Missing CONFIG_NAME"}

# create-service-key if not exist
service_key_name="${service_name}_sk"
cf create-service-key ${service_name} ${service_key_name}

# get credentials
service_key_guid=$(cf service-key ${service_name} ${service_key_name} --guid)
credentials=$(cf curl /v2/service_keys/${service_key_guid} | jq -c .entity.credentials)

# read credentials
access_token_uri=$(echo ${credentials} | jq -r .access_token_uri)
client_id=$(echo ${credentials} | jq -r .client_id)
client_secret=$(echo ${credentials} | jq -r .client_secret)
config_server_uri=$(echo ${credentials} | jq -r .uri)

# get bearer token
oauth_token=$(curl  -k \
                    -X POST ${access_token_uri} \
                    -d "grant_type=client_credentials&client_id=${client_id}&client_secret=${client_secret}" \
                    --silent)

bearer_token=$(echo ${oauth_token} | jq -r .access_token)


# get decrypted config file
echo "GET ${config_server_uri}/${config_name}" >&2
response=$(curl -k \
                -H "Authorization: Bearer ${bearer_token}" \
                -X GET ${config_server_uri}/${config_name} \
                --silent)

echo ${response}
