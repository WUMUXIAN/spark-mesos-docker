FROM ubuntu:14.04 
MAINTAINER Wu Muxian "wumuxian1988@gmail.com"

ENV DEBIAN_FRONTEND noninteractive
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.9-src.zip

RUN mkdir /scripts

# install mesos
COPY scripts/setup_mesos_repo.sh /scripts
RUN sh /scripts/setup_mesos_repo.sh
RUN apt-get -y update && apt-get install -y --force-yes mesos=0.27.0-0.2.190.ubuntu1404
RUN apt-get install -y curl

# install and configurate spark
RUN curl http://d3kbcqa49mib13.cloudfront.net/spark-1.6.0-bin-hadoop2.6.tgz -o /tmp/spark-1.6.0-bin-hadoop2.6.tgz \
    && tar -xzf /tmp/spark-1.6.0-bin-hadoop2.6.tgz -C /usr/local/ \
    && ln -s /usr/local/spark* /usr/local/spark \
    && rm -f /tmp/spark-1.6.0-bin-hadoop2.6.tgz

COPY scripts/get_dependencies.sh /scripts/get_dependencies.sh
RUN mkdir /usr/local/spark/dependencies
RUN bash /scripts/get_dependencies.sh

WORKDIR /usr/local/spark

COPY scripts/mesos_run.sh /scripts/mesos_run.sh

ENTRYPOINT ["/scripts/mesos_run.sh"]
