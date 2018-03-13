#!/bin/bash

set -e

# Check if CLI args list containes bind address key.
cli_bind_address() {
  echo "$*" | grep -qE -- "--host\b|-h\b|--ip\b|-i\b"
}

# Set permissions on the scratch volumes
scratch_volumes_permissions() {
  chmod 1777 /tmp
}

cat > $SPARK_HOME/conf/spark-defaults.conf << EOF
spark.executor.extraClassPath  $SPARK_HOME/dependencies/*
spark.driver.extraClassPath  $SPARK_HOME/dependencies/*
EOF

## Configuration sourcing
. $SPARK_HOME/sbin/spark-config.sh
. $SPARK_HOME/bin/load-spark-env.sh

scratch_volumes_permissions

# master or worker or shell
case $1 in
master|worker)
    instance=$1
    shift
    CLASS="org.apache.spark.deploy.$instance.${instance^}"

    opts="$@"

    # Handle custom bind address set via ENV or CLI
    echo "==> spark-class invocation arguments: $CLASS ${opts}"

    cd /tmp
    exec $SPARK_HOME/bin/spark-class $CLASS ${opts}
  ;;
shell)
    shift
    echo "==> spark-shell invocation arguments: $@"

    cd /tmp
    exec $SPARK_HOME/bin/spark-shell $@
  ;;
*)
    cmdline="$@"
    exec ${cmdline:-/bin/bash}
  ;;
esac
