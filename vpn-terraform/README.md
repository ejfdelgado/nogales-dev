## Terraform
```
export GOOGLE_APPLICATION_CREDENTIALS=<PATH_TO>/local-volt-431316-m2-4fe954a04994.json

terraform init

terraform workspace new pro
terraform workspace new stg

terraform workspace select stg && terraform apply -var-file="env.stg.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit

terraform workspace select pro && terraform apply -var-file="env.pro.tfvars" && ffplay /sound/finish.mp3 -nodisp -nostats -hide_banner -autoexit
```

The VPN docker image came from: https://hub.docker.com/r/linuxserver/wireguard

```
nmap -sU -p 51820 34.94.114.14
nmap -sU -p 51820 34.171.61.38
```