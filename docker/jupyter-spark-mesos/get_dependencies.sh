HADOOP_AWS_JAR=hadoop-aws-2.7.1.jar
HADOOP_AWS_JAR_URL=http://central.maven.org/maven2/org/apache/hadoop/hadoop-aws/2.7.1/$HADOOP_AWS_JAR

AWS_JAVA_SDK_JAR=aws-java-sdk-1.7.4.jar
AWS_JAVA_SDK_JAR_URL=http://central.maven.org/maven2/com/amazonaws/aws-java-sdk/1.7.4/$AWS_JAVA_SDK_JAR

GOOGLE_COLLECTIONS=google-collections-0.9.jar
GOOGLE_COLLECTIONS_URL=http://central.maven.org/maven2/com/google/collections/google-collections/0.9/$GOOGLE_COLLECTIONS

MYSQL_JAVA_CONNECTOR=mysql-connector-java-5.1.38.jar
MYSQL_JAVA_CONNECTOR_URL=http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.38/$MYSQL_JAVA_CONNECTOR

EXTRA_JARS_DIR=/usr/local/spark/dependencies

function get_jar_file {
  if [ ! -e ${EXTRA_JARS_DIR}/$1 ];
  then
    curl -L -k $2 -o ${EXTRA_JARS_DIR}/$1
  fi
}

get_jar_file $HADOOP_AWS_JAR $HADOOP_AWS_JAR_URL
get_jar_file $AWS_JAVA_SDK_JAR $AWS_JAVA_SDK_JAR_URL
get_jar_file $MYSQL_JAVA_CONNECTOR $MYSQL_JAVA_CONNECTOR_URL
get_jar_file $GOOGLE_COLLECTIONS $GOOGLE_COLLECTIONS_URL
