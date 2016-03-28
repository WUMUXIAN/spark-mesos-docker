DOCKER_MACHINE=${DOCKER_MACHINE:-mydockermachine}
HOST_IP=$(docker-machine ip $DOCKER_MACHINE)
SPARK_IMAGE=${SPARK_IMAGE:-wumuxian/spark-mesos:1.6.0-0.27.0}
SPARK_MASTER=${SPARK_MASTER:-mesos://zk://${HOST_IP}:2181/mesos}

echo $HOST_IP

docker run -d \
    --net host \
    --name "spark-mesos-dispatcher" \
    -e SPARK_IMAGE=$SPARK_IMAGE \
    -e SPARK_MASTER=$SPARK_MASTER \
    $SPARK_IMAGE \
    sh -c "/usr/local/spark/bin/spark-class org.apache.spark.deploy.mesos.MesosClusterDispatcher --name "MySparkCluster" --master ${SPARK_MASTER}"
