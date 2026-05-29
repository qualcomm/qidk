Support:
========

This docker file can be used on SNPE and QNN Versions: 2.25 and above

Prerequisites:
==============
- Docker installed and running on your host machine
- (Optional) Android NDK — downloaded automatically inside the image if not present

Note: QAIRT SDK (v2.46.0.260424) and Android NDK (r26c) are downloaded automatically during docker image build.

------------------------------------------------------------
Quick Start (Single Command)
------------------------------------------------------------

Use the provided ``run_qairt_docker.sh`` script to build the image and start
the container in one shot:

    cd Tools/qairt_docker
    ./run_qairt_docker.sh

This script performs three steps automatically:
  1. Builds the Docker image (downloads QAIRT SDK + Android NDK inside the image)
  2. Removes any existing container with the same name to avoid conflicts
  3. Starts a new detached container with the correct mount and network settings

Script Options:
---------------

    ./run_qairt_docker.sh [OPTIONS]

    -i, --image     IMAGE_NAME      Docker image name            (default: qairt)
    -c, --container CONTAINER_NAME  Docker container name        (default: qairt_container)
    -m, --mount     HOST_PATH       Host directory to bind-mount (default: /local/)
    -t, --target    TARGET_PATH     Path inside the container    (default: /local/)
    --no-cache                      Force a fresh image build (no layer cache)
    --skip-build                    Skip image build, only (re)start the container
    -h, --help                      Show usage help

Examples:

    # Default — image: qairt, container: qairt_container, mount: /local/ -> /local/
    ./run_qairt_docker.sh

    # Custom image and container name
    ./run_qairt_docker.sh -i my_qairt -c my_container

    # Mount a custom host directory into the container
    ./run_qairt_docker.sh -m /home/user/workspace -t /workspace

    # Force rebuild from scratch (no Docker layer cache)
    ./run_qairt_docker.sh --no-cache

    # Restart container without rebuilding the image
    ./run_qairt_docker.sh --skip-build

------------------------------------------------------------
Manual Steps (without the script)
------------------------------------------------------------

Step 1 — Build the image:

    docker build -t qairt .

Step 2 — Create a container:

    docker run --net host -dit --name qairt_container \
      --mount type=bind,source="/local/",target="/local/" qairt:latest

Step 3 — Open the container:

    docker exec -it qairt_container /bin/bash

------------------------------------------------------------
Remove Docker Container / Image (if needed)
------------------------------------------------------------

These steps are NOT mandatory. Use them only to clean up containers no longer in use.

1. List all containers:

        docker ps -a

2. Stop a running container:

        docker stop <CONTAINER_ID>

3. Remove the container:

        docker rm <CONTAINER_ID>

4. List all images:

        docker images

5. Remove the image:

        docker rmi -f <IMAGE_ID>
