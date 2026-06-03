## Videocall

Check free disk space

1. Go to [VM instances](https://console.cloud.google.com/compute/instances?project=local-volt-431316-m2).
2. Use ssh -> Open in browser window.
3. Run the command ``` df -h ```
4. Check the path **/mnt/stateful_partition**, if it is full, then prune all docker images using the next step.
5. Prune all docker images with ``` docker rmi -f $(docker images -aq) ```

Note: as an alternative to ssh into the instances:
```
# For production server videocall
ssh ejfdelgado@34.171.61.38
# For stage server videocall
ssh ejfdelgado@104.197.163.219
```

```
docker ps
docker exec -it d5f514056573 /bin/bash
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