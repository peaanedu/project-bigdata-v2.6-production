#!/usr/bin/env bash
set -euo pipefail
mkdir -p /data/hdfs/namenode
chown -R hadoop:hadoop /data/hdfs
if [ ! -d /data/hdfs/namenode/current ]; then
  echo "Formatting NameNode metadata..."
  su -s /bin/bash hadoop -c "hdfs namenode -format -nonInteractive -force"
fi
exec su -s /bin/bash hadoop -c "hdfs namenode"
