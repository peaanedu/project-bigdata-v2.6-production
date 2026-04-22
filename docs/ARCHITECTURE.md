# Architecture

Power BI connects through Trino by ODBC. Trino reads Hive metadata from the Hive Metastore, and Hive points to tables stored in HDFS.

Flow:
Power BI -> Trino -> Hive Metastore -> HDFS
