# Disclaimer
These repository is not official. There are no official support for these images and deployment. I made it for myself for lab purpose.

You need have official KUMA disrtibution which is not public. Thats why i do not publish images to public repository.

# Description
These are docker images definition (docker files) and compose file to deploy quickly a simple deployment of Kaspersky Unified Monitoring and Analysis Platform SIEM aka KUMA on a single Linux host.

KUMA SIEM consists of several components (please [refer to the offical Kaspersky documentation](https://support.kaspersky.com/help/KUMA/3.0.2/en-US/217958.htm)). 
There are serveral folders for each one:
* kuma-collector - KUMA Collector 
* kuma-core-aio - KUMA Core
* kuma-correlator - KUMA Corellator
* kuma-storage - KUMA Storage

These folders contains Dockerfile's and files to build image for specific KUMA component. 

Images development is based on official ansible installation script distributed by Kaspersky to install KUMA.

You need podman to run container for these images. It is not possible to use docker engine for this. This because [systemd used inside these images](https://developers.redhat.com/blog/2019/04/24/how-to-run-systemd-in-a-container).

compose.yaml contains compose definition to build and run easily all posible KUMA component on your host using podman-compose.

# Prerequisites
* Host with Linux (i used Ubuntu 22.04.3 LTS on Windows WSL2 instead)
* Podman installed on Linux host (tested with 3.4.4 version)
* podman-compose installed on Linux host (tested with version 1.0.6)
* official tar archive with KUMA distribution (for example, kuma-ansible-installer-3.0.2.37.tar.gz)
# Usage
Run on Linux host:

* `git clone <link to this git repository>`

* `cd KUMAContainers`

* place KUMA distribution (tested with kuma-ansible-installer-3.0.2.37.tar.gz only) to resources\kuma-dist subdirectory

## Build and Run KUMA Deployment

* `sudo podman-compose`

## Login to KUMA

Open KUMA Core Web UI in Browser:

https://localhost:7220

## Build Image for Specific KUMA Component
In the KUMAContainers folder:
* `podman build -t kuma-core-aio:test -f kuma-core-aio/Dockerfile .`

Next you are able to run container with this image

* `podman run -d --name kuma-core-01 kuma-core-aio:test`


