#!/bin/bash

HADOOP_AWS_JAR=hadoop-aws-2.7.3.jar
HADOOP_AWS_JAR_URL=http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.3/$HADOOP_AWS_JAR

AWS_JAVA_SDK_JAR=aws-java-sdk-1.7.4.jar
AWS_JAVA_SDK_JAR_URL=http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/$AWS_JAVA_SDK_JAR

EXTRA_JARS_DIR=/usr/local/spark/dependencies

function get_jar_file {
  if [ ! -e ${EXTRA_JARS_DIR}/$1 ];
  then
    wget -O ${EXTRA_JARS_DIR}/$1 $2
  fi
}

get_jar_file $HADOOP_AWS_JAR $HADOOP_AWS_JAR_URL
get_jar_file $AWS_JAVA_SDK_JAR $AWS_JAVA_SDK_JAR_URL
