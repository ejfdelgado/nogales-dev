
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