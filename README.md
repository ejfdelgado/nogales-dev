# Nogales Develop

Hello team ❤️. First install the development tools, then, configure, finally run.

## Development tools
- Version control tool: Git [https://git-scm.com/downloads]
- Code editor: Visual Studio Code [https://code.visualstudio.com/]
- Running platform: Docker [https://www.docker.com/products/docker-desktop/]

## Configurations

```
nano ~/.ssh/config
```
Place on it:
```
Host nogales
  HostName github.com
  IdentityFile ~/.ssh/id_ed25519
```
## Run

## Terraform
```
export GOOGLE_APPLICATION_CREDENTIALS=/home/ejfdelgado/desarrollo/nogales-assessment/credentials/local-volt-431316-m2-4fe954a04994.json

terraform init
terraform plan
terraform state rm

terraform workspace new pro
terraform workspace new stg

terraform workspace select stg && terraform apply -var-file="env.stg.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit

terraform workspace select pro && terraform apply -var-file="env.pro.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
```
vi /usr/local/bin/docker-entrypoint.sh
ssh ejfdelgado@34.171.61.38
ssh ejfdelgado@104.197.163.219
docker ps

ssh -i ~/.ssh/your_file rodalbores@104.197.163.219
 


docker exec -it 8c032cc8e6a6 /bin/bash
docker logs -f 22625d771890

Consume request ignored: producer missing or closed

Error: NO receive transport on ejdelgado.pat_public_6c36e9a2_6f1c_4e57_80c9_2b1b6b971af3

Error: NO receive transport on ejdelgado.sig_ejdelgado

