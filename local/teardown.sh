DOCKER_MACHINE=mydockermachine
eval $(docker-machine env $DOCKER_MACHINE)
docker stop mesos-master mesos-slave zookeeper marathon chronos
docker rm mesos-master mesos-slave zookeeper marathon chronos
