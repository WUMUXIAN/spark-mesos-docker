FROM python:3.6.4-alpine3.4
MAINTAINER Wu Muxian "wumuxian1988@gmail.com"

# add a simple script that can auto-detect the appropriate JAVA_HOME value
# based on whether the JDK or only the JRE is installed
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin

ENV JAVA_VERSION 8u111
ENV JAVA_ALPINE_VERSION 8.111.14-r0

RUN set -x \
	&& apk add --no-cache \
		openjdk8-jre="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]

ENV SPARK_HOME /usr/local/spark
ENV PATH $JAVA_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin:$PATH
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip

# Set python3 as the default
ENV PYSPARK_PYTHON python3

RUN mkdir /scripts

# install and configure spark
RUN wget -O /tmp/spark-2.2.1-bin-hadoop2.7.tgz http://www-us.apache.org/dist/spark/spark-2.2.1/spark-2.2.1-bin-hadoop2.7.tgz \
    && tar -xzf /tmp/spark-2.2.1-bin-hadoop2.7.tgz -C /usr/local/ \
    && ln -s /usr/local/spark* /usr/local/spark \
    && rm -f /tmp/spark-2.2.1-bin-hadoop2.7.tgz \
    && cp /usr/local/spark/conf/log4j.properties.template /usr/local/spark/conf/log4j.properties

WORKDIR /usr/local/spark

# install bash
RUN apk add --no-cache bash

# Download the dependencies that are needed for accessing Amazon S3
COPY scripts/get_dependencies.sh /scripts/get_dependencies.sh
RUN mkdir /usr/local/spark/dependencies
RUN bash /scripts/get_dependencies.sh

COPY scripts/entrypoint.sh /scripts/entrypoint.sh

VOLUME [ "/usr/local/spark/work", "/tmp" ]

EXPOSE 4040 8080 8081 7077 6066

ENTRYPOINT ["/scripts/entrypoint.sh"]
