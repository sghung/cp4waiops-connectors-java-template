#!/bin/bash
set -euo pipefail

clientID=782cb888-b565-4e0b-be17-5d08ad16d680
clientSecret=qO6ljMDvAUVtCe6IamSKmTj2Sr3Im6SYYqdSFeDW2XEoQazWEFKtKj5WA8fN
id=782cb888-b565-4e0b-be17-5d08ad16d680
type=java-grpc-connector-template
caCertificate="COPY contents to certs/ca.crt"
tlscrt="COPY contents to certs/tls.crt"
tlskey="COPY contents to certs/tls.key"
host=HOSTHIDDEN
port=443
image=docker.io/sghung/sample-java-template:latest
bindings_dir=$(pwd)/connector-${id}
grpc_bridge_dir=${bindings_dir}/grpc-bridge
connector_dir=${bindings_dir}/${type}
cacrt_file=${grpc_bridge_dir}/ca.crt
tlscrt_file=${grpc_bridge_dir}/tls.crt
tlskey_file=${grpc_bridge_dir}/tls.key
host_file=${grpc_bridge_dir}/host
port_file=${grpc_bridge_dir}/port
id_file=${grpc_bridge_dir}/id
clientid_file=${grpc_bridge_dir}/client-id
clientsecret_file=${grpc_bridge_dir}/client-secret
mkdir -p $grpc_bridge_dir
mkdir -p $connector_dir
chmod 775 $connector_dir

echo "${caCertificate}" > $cacrt_file
echo "${tlscrt}" > $tlscrt_file
echo "${tlskey}" > $tlskey_file
echo $host > $host_file
echo $port > $port_file
echo $id > $id_file
echo $clientID > $clientid_file
echo $clientSecret > $clientsecret_file
set +e
podman pull $image
if [ $? -ne 0 ]; then echo; echo 'image could not be pulled, login using:'; echo 'podman login docker.io'; exit 1; fi
set -e
podman run -v $bindings_dir:/bindings -d --name aiops-connector-782cb888-b565-4e0b-be17-5d08ad16d680 --replace $image
echo
echo 'To follow the container logs, execute:'
echo 'podman logs -f aiops-connector-782cb888-b565-4e0b-be17-5d08ad16d680'