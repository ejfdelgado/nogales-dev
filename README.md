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
cd /home/ejfdelgado/desarrollo/yolo/imageia/terraform
export GOOGLE_APPLICATION_CREDENTIALS=/home/ejfdelgado/desarrollo/nogales-assessment/credentials/local-volt-431316-m2-4fe954a04994.json
terraform init
terraform plan
terraform state rm
terraform apply -var-file="env.pro.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
