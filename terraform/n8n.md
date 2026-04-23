
1. enviar n8nio/n8n:latest a gcp.

1.1. Check the last n8n version at [hub.docker.com](https://hub.docker.com/r/n8nio/n8n/tags)

1.2. Bring the image to local
```
docker pull n8nio/n8n:2.17.5
```
1.3. Tag it locally into the gcp format
```
docker tag n8nio/n8n:2.17.5 us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5
```
1.4. Push it into gcp

1.4.1. Login into gcp
```
gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://us-central1-docker.pkg.dev
```
1.4.2. Push the image itself
```
docker push us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5
```

2. Prepare env variables
2.1. Create the N8N_ENCRYPTION_KEY
```
openssl rand -hex 32
```

3. Prepare database schema

3.1. Create schema "rag" and "n8n"

3.2. Allow vector feature on postgres
```
CREATE EXTENSION IF NOT EXISTS vector;
```

4. Adjusting the docker image including the way to access database via private network.
4.1. Get into the docker image
```
docker exec -it -u root 39b9d987713d /bin/sh
```

4.2. Perform the needed changes (Option 1)
```
cd /usr/local/bin && mkdir google && cd google

wget -O /usr/local/bin/google/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.linux.amd64

chmod 755 /usr/local/bin/google/cloud-sql-proxy
```

4.3. 
```
docker commit 39b9d987713d us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5.1
```

4.4.
```
/tmp/app/cloud-sql-proxy --port=5432 "$INSTANCE_CONNECTION_NAME" &
```

5. Perform the needed changes (Option 2)

5.1. Create the file custom-entrypoint.sh:
```
#!/bin/sh
set -e

# Start Cloud SQL Proxy in background
/usr/local/bin/google/cloud-sql-proxy --port=5432 "$INSTANCE_CONNECTION_NAME" &

# Wait for proxy to be ready
sleep 2

# Run the original n8n entrypoint
exec /docker-entrypoint.sh "$@"

5.2. Create the file Dockerfile
```
FROM n8nio/n8n:2.17.5

USER root

# Copy your Cloud SQL Proxy binary
RUN mkdir -p /usr/local/bin/google
RUN wget -O /usr/local/bin/google/cloud-sql-proxy https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.8.0/cloud-sql-proxy.linux.amd64

# Copy custom entrypoint
COPY custom-entrypoint.sh /custom-entrypoint.sh

RUN chmod 755 /usr/local/bin/google/cloud-sql-proxy && \
    chmod 755 /custom-entrypoint.sh

USER node

ENTRYPOINT ["/custom-entrypoint.sh"]
CMD []
```

5.3. Build it
```
docker build -t us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/n8n:2.17.5.2 .
```