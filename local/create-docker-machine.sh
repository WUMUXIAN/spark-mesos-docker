echo "Creating docker machine"
DOCKER_MACHINE=${DOCKER_MACHINE:-mydockermachine}
docker-machine create -d virtualbox --virtualbox-memory "4096" --virtualbox-cpu-count "4" mydockermachine
