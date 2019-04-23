# Run OpenHAB Docker image

Source: https://www.openhab.org/docs/installation/docker.html

## Create the openhab user

Use:

```bash
sudo useradd -r -s /sbin/nologin openhab
```

Add your regular user to the openhab group.

```bash
usermod -a -G openhab <user>
```

## Create the openHAB conf, userdata, and addon directories

These directories will be mounted into the running Docker container and are where the configurations and persistence data will be stored. Note that the software running inside a Docker container cannot follow the symbolic links located in a mounted volume. Make sure the openhab user owns these directories.

```bash
mkdir /opt/openhab
mkdir /opt/openhab/conf
mkdir /opt/openhab/userdata
mkdir /opt/openhab/addons
chown -R openhab:openhab /opt/openhab
```

# Run the Container as a Service Managed by Docker

```bash
docker run \
        --name openhab \
        --net=host \
        -v /etc/localtime:/etc/localtime:ro \
        -v /etc/timezone:/etc/timezone:ro \
        -v /opt/openhab/conf:/openhab/conf \
        -v /opt/openhab/userdata:/openhab/userdata \
        -v /opt/openhab/addons:/openhab/addons\
        -d \
        -e USER_ID=<uid> \
        -e GROUP_ID=<gid> \
        --restart=always \
        openhab/openhab:<version>-<architecture>-<distribution>
```
