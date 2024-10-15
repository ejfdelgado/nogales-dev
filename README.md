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
export GOOGLE_APPLICATION_CREDENTIALS=/home/ejfdelgado/desarrollo/widesight-core/credentials/rosy-valor-429621-b6-841682b6208d.json
terraform init
terraform plan
terraform apply -auto-approve && play /sound/finish.mp3
```