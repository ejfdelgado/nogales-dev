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
Pro:
ssh ejfdelgado@34.171.61.38
Stg:
ssh ejfdelgado@104.197.163.219
docker ps
docker exec -it 092f96adacaf /bin/bash
docker logs -f e4e8079edbb8

df -h && docker rmi -f $(docker images -aq)

ssh -i ~/.ssh/your_file rodalbores@104.197.163.219
 


docker exec -it 8c032cc8e6a6 /bin/bash
docker logs -f 22625d771890



