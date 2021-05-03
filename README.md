# Patroni Raft Docker

A docker image running Patroni PostgreSQL using the python pysyncobj module for the DCS.
Together with the docker-compose file it runs 3 PostgreSQL nodes with automatic failover, 1 hot-standy with synchronous replication and 1 hot-standby with asynchronous replication.