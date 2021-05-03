FROM postgres:13

# Install pip psycopg2 patroni
RUN apt-get update && \
    apt-get install -y python3-pip && \
    pip3 install psycopg2-binary==2.8.6 && \
    pip3 install patroni[raft]==2.0.2

WORKDIR /app

# Add PG13 tools to path
RUN PATH=$PATH:/usr/lib/postgresql/13/bin

# Make postgres user the owner of the app directory
RUN chown -R postgres: /app

USER postgres

# Create data directories with correct permissions for postgres
RUN mkdir data && \ 
    mkdir data/postgres && \
    mkdir data/raft && \
    chmod -R 700 data

COPY postgres.yml postgres.yml
COPY entrypoint.sh entrypoint.sh

ENTRYPOINT ["/bin/sh", "entrypoint.sh"]