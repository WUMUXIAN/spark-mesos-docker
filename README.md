# Intro
This project aims to help with the following things:
- Fire up a full minimum mesos cluster containing 1 zookeeper, 1 master and 1 slave, with Marathon and Chronos running.
- Run a jupyter notebook server with spark 1.6.0 and mesos 0.28.0 installed.
- Develop spark codes using jupyter and run directly with the Mesos cluster.

**Note: Everything runs on docker and for now it only runs on a single machine with docker-machine and virtualbox installed.**

# Getting Started
If you don't have docker-machine and virtualbox installed yet. Do it.

- [Docker Machine](https://docs.docker.com/machine/install-machine/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)

Now you can:
```shell
cd local

# If you don't have a 4G memory docker machine running yet, you can create one by:
DOCKER_MACHINE=your-docker-machine-name
. create-docker-machine.sh

#Fire up the Mesos cluster:
DOCKER_MACHINE=your-docker-machine-name
. firup.sh
```

Up to this point you should see a full minumum mesos cluster running in docker, you can find the images we use,
it's from [Mesosphere](https://hub.docker.com/u/mesosphere/) and [Mesoscloud](https://hub.docker.com/u/mesoscloud/) 
```
CONTAINER ID        IMAGE                                                                                             NAMES
50fcae67dd93        mesosphere/chronos:chronos-2.4.0-0.1.20150828104228.ubuntu1404-mesos-0.27.0-0.2.190.ubuntu1404    chronos
ce8e179d6b47        mesosphere/marathon:v0.15.1                                                                       marathon
47fb4e062ba1        mesosphere/mesos-slave:0.27.0-0.2.190.ubuntu1404                                                  mesos-slave
82bac0ea3cb4        mesosphere/mesos-master:0.27.0-0.2.190.ubuntu1404                                                 mesos-master
a909378e4ec2        mesoscloud/zookeeper:3.4.6-ubuntu-14.04                                                           zookeeper
```

# Building Required images
Now to Run the Jupyter Notebook server you have to build the image first:
```shell
cd docker/jupyter-spark-mesos/
IMAGE=yourpreferredname
. build
```
*Note: I refer to jupyter/minial-notebook from the 
[jupyter docker stacks](https://github.com/jupyter/docker-stacks), but I use mesos 0.28.0 instead to fix a zookeeper bug 
on mesos 0.22.1*

To Enable the Mesos to run Spark Excecutor, you have to get a spark image ready to use:
```shell
cd docker/spark-mesos/
IMAGE=yourpreferredname
VERSION=yourpreferredtag
. build
```

# Running Jupyter and writting spark job to run on Mesos Cluster
Now run the jupyter server using:
```shell
cd local/
DOCKER_MACHINE=your-docker-machine-name
SPARK_IMAGE=your-spark-image
. run_jupyter.sh
```
And you should see it's running as a container:
```
CONTAINER ID        IMAGE                                                                                            NAMES
3bc3c8057c9f        wumuxian/jupyter-spark-mesos                                                                     jupyter-spark-mesos
```

Go to the jupyter web UI at http://your-docker-machine-ip:8888 and open a python2 notebook and run the following code:
```python
import pyspark
import os
# make sure pyspark tells workers to use python3 not 2 if both are installed
os.environ['PYSPARK_PYTHON'] = '/usr/bin/python2'
# replace your-docker-machine-ip with your actual ip address.
sc = pyspark.SparkContext("mesos://zk://your-docker-machine-ip/mesos")

# do something to prove it works
rdd = sc.parallelize(range(1000))
rdd.takeSample(False, 5)
```
And you will see some output similar to:
```
[583, 32, 266, 563, 488]
```

Now check your docker containers, you will realize that your mesos slave actually started spark excecutor with docker:
```
CONTAINER ID        IMAGE                                                                                            NAMES
2318ef4ee73c        wumuxian/spark-mesos:1.6.0-0.27.0                                                                mesos-bf9e7d05-2524-4b87-807d-03923d56f9f6-S0.5309ad48-8ffa-4b28-a8b5-ca34d9be6330
```

Till now you already have a full minimum Mesos Cluster running on your docker machine and you have a jupyter notebook running,
on which you can write your spark jobs and submit it to Mesos, enjoy.

If you wish to tear down the cluster, do the following:
```shell

#Tear down the Mesos cluster:
DOCKER_MACHINE=your-docker-machine-name
. teardown.sh
```
This will remove all the spark executor containers, jupyter server container and all the mesos related containers.

#Reference
[wangqiang8511/spark-demo](https://github.com/wangqiang8511/spark-demo)
[jupyter/docker-stacks](https://github.com/jupyter/docker-stacks)

