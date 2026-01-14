wordpress:php8.2-apache

docker tag wordpress:php8.2-apache us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:1.0.0

gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://us-central1-docker.pkg.dev

docker build --no-cache=true -t us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.4 -f Dockerfile .

docker push us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.4

```
docker exec -it d18f7f2df5b5 sh
vi /etc/nginx/http.d/default.conf
docker commit d18f7f2df5b5 us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:3.0.3
```