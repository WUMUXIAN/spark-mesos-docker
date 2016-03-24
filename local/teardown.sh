DOCKER_MACHINE=${DOCKER_MACHINE:-mydockermachine}
eval $(docker-machine env $DOCKER_MACHINE)
docker stop mesos-master mesos-slave zookeeper marathon chronos jupyter-spark-mesos
docker rm mesos-master mesos-slave zookeeper marathon chronos jupyter-spark-mesos

function rm_spark_executors {
    sparkexecutors=`docker ps -a -q -f="ancestor=wumuxian/spark-mesos:1.6.0-0.27.0"`
    if [[ ! -z $sparkexecutors ]]
    then
        docker rm $sparkexecutors
    else
        echo "No spark executors to remove"
    fi
}

rm_spark_executors
