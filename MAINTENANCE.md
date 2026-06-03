## Videocall

Check free disk space

1. Go to [VM instances](https://console.cloud.google.com/compute/instances?project=local-volt-431316-m2).
2. Use ssh -> Open in browser window.
3. Run the command ``` df -h ```
4. Check the path **/mnt/stateful_partition**, if it is full, then prune all docker images using the next step.
5. Prune all docker images with ``` docker rmi -f $(docker images -aq) ```