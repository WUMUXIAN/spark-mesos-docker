SPARK_HOME=/usr/local/spark
SPARK_MASTER=${SPARK_MASTER:-local[*]}
ROOT_LOG_LEVEL=${ROOT_LOG_LEVEL:-WARN}
MESOS_EXECUTOR_CORE=${MESOS_EXECUTOR_CORE:-0.1}
SPARK_IMAGE=${SPARK_IMAGE}
CURRENT_IP=$(hostname -i)

cat > $SPARK_HOME/conf/spark-env.sh << EOF
#!/usr/bin/env bash
export MESOS_NATIVE_JAVA_LIBRARY=${MESOS_NATIVE_JAVA_LIBRARY:-/usr/lib/libmesos.so}
EOF
chmod +x $SPARK_HOME/conf/spark-env.sh

cat > $SPARK_HOME/conf/spark-defaults.conf << EOF
spark.master                      $SPARK_MASTER
spark.mesos.mesosExecutor.cores   $MESOS_EXECUTOR_CORE
spark.mesos.executor.docker.image $SPARK_IMAGE
spark.mesos.executor.home        $SPARK_HOME
spark.driver.host $CURRENT_IP
spark.executor.extraClassPath  $SPARK_HOME/dependencies/*
spark.driver.extraClassPath  $SPARK_HOME/dependencies/*
EOF

# Handle special flags if we're root
if [ $UID == 0 ] ; then
# Change UID of NB_USER to NB_UID if it does not match
if [ "$NB_UID" != $(id -u $NB_USER) ] ; then
usermod -u $NB_UID $NB_USER
chown -R $NB_UID $CONDA_DIR
fi

# Enable sudo if requested
if [ ! -z "$GRANT_SUDO" ]; then
echo "$NB_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/notebook
fi

# Start the notebook server
exec su $NB_USER -c "env PATH=$PATH jupyter notebook $*"
else
# Otherwise just exec the notebook
exec jupyter notebook $*
fi
