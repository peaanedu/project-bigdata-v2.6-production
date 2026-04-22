#!/usr/bin/env bash
set -euo pipefail
mkdir -p /data/hdfs/datanode
chown -R hadoop:hadoop /data/hdfs
exec su -s /bin/bash hadoop -c "hdfs datanode"
