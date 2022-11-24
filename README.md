# infra-cleanup

Cleanup Infra on weekend.

## ssh into LKE hosts

- https://github.com/appscodelabs/dssh/tree/master

## Expand Volumes in LKE

source: https://www.linode.com/community/questions/20784/volume-expansion-in-lke#answer-75996

- Expand PVC spec
- Run the pods so disk is mounted in the host, ssh into host and run 

```
df -h
resize2fs /dev/disk/filesystem/path
df -h
```
