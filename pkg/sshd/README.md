# SSH Server

## Metadata

You can get ssh authorized_keys from [metadata(cloud-init)](https://github.com/linuxkit/linuxkit/blob/master/docs/metadata.md).

Supported Format:

```yaml
#cloud-config
user: root # Username: If not exist, create it.
password: $5$hiEDPG5d$wbdgeZ/pRt4DdEunv49f9vgfjqfdbVJOkbfS../Qo07 # Both hashed and plain passwords are available.
ssh_authorized_keys:
  - SSH PUBLIC KEY 1
  - SSH PUBLIC KEY 2
```

