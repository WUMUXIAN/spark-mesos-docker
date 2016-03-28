DOCKER_MACHINE=${DOCKER_MACHINE:-mydockermachine}
eval $(docker-machine env $DOCKER_MACHINE)
docker stop mesos-master mesos-slave zookeeper marathon chronos 
docker rm mesos-master mesos-slave zookeeper marathon chronos 

function rm_jupyter {
    jupyter=`docker ps -a -q -f="ancestor=wumuxian/jupyter-spark-mesos"`
    if [[ ! -z $jupyter ]] 
    then
        docker rm -f $jupyter
    else
        echo "Jupyter not running"
    fi
}

function rm_spark_executors {
    sparkexecutors=`docker ps -a -q -f="ancestor=wumuxian/spark-mesos:1.6.0-0.27.0"`
    if [[ ! -z $sparkexecutors ]]
    then
        docker rm -f $sparkexecutors
    else
        echo "No spark executors to remove"
    fi
}

rm_jupyter
rm_spark_executors
