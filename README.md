# Patroni Raft Docker

A docker image running Patroni PostgreSQL using the python pysyncobj module which implements Raft to provide a Distributed Configuration Store (DCS) and leader elections. No other infrastructure to provide Patorni with a DCS is required which simplifies the setup to just patroni nodes and a single proxy to direct database connections to the master node.

Note: The Patroni Raft module is currently in beta and is not yet recommended for production environments

## Build

```
docker build -t spgcontrols/postgresql-patroni-raft:<tag> .
```

## Pull

```
docker pull spgcontrols/postgresql-patroni-raft:<tag>
```

## Example

```
./run.sh <version> <stack_name>

or 

docker stack deploy -c docker-compose.yml <stack_name>
```

The docker-compose.yml file runs 3 PostgreSQL / Patroni nodes with 1 master and automatic failover if it goes down.

Of the 2 standby nodes, one is a hot-standby (read-only) with asynchronous replication and the other is a hot-standy with synchronous replication to guarentee all writes are successful on 2 out of the 3 nodes before returning to the client. This means in the event of a failover the synchronous standby will be up to date and can safely take over as the new master without the cluster losing any data and the other standy will take over as the synchronous standby.

Strict synchronous mode has been enabled so no writes will be accepted if 2 of the servers go down since no loss of data can be guarenteed in this scenario. All of these settings can be adjusted in the postgres.yml file.