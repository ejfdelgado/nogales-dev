wordpress:php8.2-apache

docker tag wordpress:php8.2-apache us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:1.0.0

gcloud auth print-access-token | docker login -u oauth2accesstoken --password-stdin https://us-central1-docker.pkg.dev

docker push us-central1-docker.pkg.dev/local-volt-431316-m2/nogales/wordpress:1.0.0