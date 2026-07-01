## Videocall

Check free disk space

1. Go to [VM instances](https://console.cloud.google.com/compute/instances?project=local-volt-431316-m2).
2. Use ssh -> Open in browser window.
3. Run the command ``` df -h ```, the response is something like:
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/root       2.0G  1.2G  769M  62% /
devtmpfs        7.0G     0  7.0G   0% /dev
tmpfs           7.1G     0  7.1G   0% /dev/shm
tmpfs           2.9G  516K  2.9G   1% /run
tmpfs           7.1G   88K  7.1G   1% /etc/machine-id
tmpfs           256K     0  256K   0% /mnt/disks
tmpfs           7.1G     0  7.1G   0% /tmp
overlayfs       7.1G   88K  7.1G   1% /etc
/dev/sda8        11M   24K   11M   1% /usr/share/oem
/dev/sda1        46G   12G   34G  26% /mnt/stateful_partition
tmpfs           2.0M  112K  1.9M   6% /var/lib/cloud
```
4. Check the Use% of the path **/mnt/stateful_partition**, if it is higher than 50%, then prune all docker images using the next step.
5. Prune all docker images with ``` docker rmi -f $(docker images -aq) ```

Note: as an alternative to ssh into the instances:
```
# For production server videocall
ssh -v -i ~/.ssh/id_ed25519 ejfdelgado@34.171.61.38
# For stage server videocall
ssh -v -i ~/.ssh/id_ed25519 ejfdelgado@104.197.163.219
ssh -i ~/.ssh/id_ed25519 ejfdelgado@104.197.163.219
```

```
docker ps
docker exec -it 5f4b17f9e0ac /bin/bash
docker logs -f d5f514056573
```

## Database

If you need to place on stage the production database:
```
# Select the correct project
gcloud config set project local-volt-431316-m2
# List all available backups
gcloud sql backups list --instance=pro-general
# Restore database
gcloud sql backups restore 1780448400000 --restore-instance=stg-general --backup-instance=pro-general
# Take into account the password is also inherited on the backup
```

## Delete manually a user

```
SELECT destroy_user( 
    'psoto@nogalespsychological.com', --User to be deleted
	'aquintana@nogalespsychological.com', --Who will be replaced if needed
    10
);
```


### Inside docker image:
Sais which process is using the 80 port
```
sudo netstat -tulpn | grep :80

ps -p 1431 -o cmd=
ps -p 1431 -o args=
ls -l /proc/1431/cwd
pgrep -a node

docker ps --no-trunc
```
