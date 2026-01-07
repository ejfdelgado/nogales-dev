
Maintenance

1. Check GCE disk free space and erase periodically old docker images:

```
# For production server videocall
ssh ejfdelgado@34.171.61.38
# For stage server videocall
ssh ejfdelgado@104.197.163.219
# Erase old docker images
df -h && docker rmi -f $(docker images -aq)
```