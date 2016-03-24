DOCKER_MACHINE=mydockermachine
eval $(docker-machine env $DOCKER_MACHINE)
HOST_IP=$(docker-machine ip $DOCKER_MACHINE)

function start_zookeeper {
    echo "Starting zookeeper"
    docker run -d \
        -e MYID=1 \
        --name=zookeeper \
        --net=host \
        --restart=always \
        mesoscloud/zookeeper:3.4.6-ubuntu-14.04
}

function start_mesos_master {
    echo "Starting mesos master"
    docker run -d \
        --name mesos-master \
        --net host \
        --restart always \
        mesosphere/mesos-master:0.27.0-0.2.190.ubuntu1404 \
        --zk=zk://${HOST_IP}:2181/mesos \
        --work_dir=/var/lib/mesos/master \
        --quorum=1 \
        --hostname=${HOST_IP}\
        --ip=${HOST_IP}\
        --no-hostname_lookup \
        --cluster=mesostest
}

function start_mesos_slave {
    echo "Starting mesos slave"
    docker run -d \
        --name mesos-slave \
        --privileged \
        --net host \
        --restart always \
        -v /usr/local/bin/docker:/usr/bin/docker:ro \
        -v /var/run/docker.sock:/var/run/docker.sock:rw \
        -v /sys:/sys:ro \
        mesosphere/mesos-slave:0.27.0-0.2.190.ubuntu1404 \
        --master=zk://${HOST_IP}:2181/mesos \
        --containerizers=docker,mesos \
        --no-switch_user
}

function start_marathon {
    echo "Starting marathon"
    docker run -d \
        --name marathon \
        --net host \
        --restart always \
        mesosphere/marathon:v0.15.1 \
        --master zk://${HOST_IP}:2181/mesos \
        --zk zk://${HOST_IP}:2181/marathon \
        --hostname ${HOST_IP}
}

function start_chronos {
    echo "Starting chronos"
    docker run -d \
        --name chronos \
        --net host \
        --restart always \
        mesosphere/chronos:chronos-2.4.0-0.1.20150828104228.ubuntu1404-mesos-0.27.0-0.2.190.ubuntu1404 \
        /usr/bin/chronos run_jar \
        --master zk://${HOST_IP}:2181/mesos \
        --zk_hosts ${HOST_IP}:2181 \
        --http_port 8081 \
        --hostname ${HOST_IP}
}

function update_etc_host {
    echo "Update /etc/hosts"
    docker-machine ssh $DOCKER_MACHINE "sudo sed -i 's/^127\.0\.0\.1 "$DOCKER_MACHINE"/127.0.0.1/g' /etc/hosts"
    docker-machine ssh $DOCKER_MACHINE "sudo sh -c 'echo "$IP $DOCKER_MACHINE" >> /etc/hosts'"
}

start_zookeeper
start_mesos_master
start_mesos_slave
start_marathon
start_chronos
update_etc_host
