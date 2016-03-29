DOCKER_MACHINE=${DOCKER_MACHINE:-mydockermachine}
HOST_IP=$(docker-machine ip $DOCKER_MACHINE)
SPARK_IMAGE=${SPARK_IMAGE:-"wumuxian/spark-mesos:1.6.0-0.27.0"}
SPARK_MASTER=${SPARK_MASTER:-"mesos://zk://${HOST_IP}:2181/mesos"}
echo Setting spark image:
echo $SPARK_IMAGE
echo Setting spark master:
echo $SPARK_MASTER
docker run --net=host --pid=host \
    -e TINI_SUBREAPER=true \
    -e SPARK_IMAGE=${SPARK_IMAGE} \
    -e SPARK_MASTER=${SPARK_MASTER} \
    --name "jupyter-spark-mesos" \
    -d wumuxian/jupyter-spark-mesos
