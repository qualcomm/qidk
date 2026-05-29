#============================================================================
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#============================================================================

#!/bin/bash
# run_qairt_docker.sh — Build the qairt Docker image and launch a container in one command.
#
# Usage:
#   ./run_qairt_docker.sh [OPTIONS]
#
# Options:
#   -i, --image     IMAGE_NAME    Docker image name       (default: qairt)
#   -c, --container CONT_NAME     Docker container name   (default: qairt_container)
#   -m, --mount     HOST_PATH     Host path to bind-mount (default: /local/)
#   -t, --target    TARGET_PATH   Container target path   (default: /local/)
#   --rebuild                     Force rebuild even if image already exists
#   --no-cache                    Force rebuild from scratch (no Docker layer cache)
#   -h, --help                    Show this help message
#
# Default behaviour:
#   - If the image already exists  → skip build, just (re)start the container
#   - If the image does not exist  → build it automatically
#   - Use --rebuild to force a rebuild at any time
#
# Examples:
#   ./run_qairt_docker.sh                          # normal daily use
#   ./run_qairt_docker.sh --rebuild                # rebuild after dockerfile changes
#   ./run_qairt_docker.sh --no-cache               # full rebuild, no cached layers
#   ./run_qairt_docker.sh -i my_qairt -c my_cont   # custom names

set -euo pipefail

# ─── defaults ────────────────────────────────────────────────────────────────
IMAGE_NAME="qairt"
CONTAINER_NAME="qairt_container"
MOUNT_SOURCE="/local/"
MOUNT_TARGET="/local/"
NO_CACHE=""
FORCE_REBUILD=false

# ─── parse arguments ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        -i|--image)       IMAGE_NAME="$2";      shift 2 ;;
        -c|--container)   CONTAINER_NAME="$2";  shift 2 ;;
        -m|--mount)       MOUNT_SOURCE="$2";    shift 2 ;;
        -t|--target)      MOUNT_TARGET="$2";    shift 2 ;;
        --rebuild)        FORCE_REBUILD=true;    shift  ;;
        --no-cache)       FORCE_REBUILD=true; NO_CACHE="--no-cache"; shift ;;
        -h|--help)
            sed -n '/^# Usage:/,/^[^#]/p' "$0" | grep '^#' | sed 's/^# \?//'
            exit 0 ;;
        *) echo "[ERROR] Unknown option: $1"; exit 1 ;;
    esac
done

# ─── resolve dockerfile directory and qidk root ──────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# QIDK root is two levels up from Tools/qairt_docker/
QIDK_HOST_PATH="$(cd "${SCRIPT_DIR}/../.." && pwd)"

# Convert host path to container path by replacing the mount source prefix
# with the mount target prefix (handles custom -m/-t values too).
MOUNT_SOURCE_TRIM="${MOUNT_SOURCE%/}"   # strip trailing slash for clean replacement
MOUNT_TARGET_TRIM="${MOUNT_TARGET%/}"
QIDK_CONTAINER_PATH="${MOUNT_TARGET_TRIM}${QIDK_HOST_PATH#${MOUNT_SOURCE_TRIM}}"

echo "============================================================"
echo "  QAIRT Docker Setup"
echo "============================================================"
echo "  Image     : ${IMAGE_NAME}"
echo "  Container : ${CONTAINER_NAME}"
echo "  Mount     : ${MOUNT_SOURCE} -> ${MOUNT_TARGET}"
echo "  Workdir   : ${QIDK_CONTAINER_PATH}"
echo "  Dockerfile: ${SCRIPT_DIR}/dockerfile"
echo "============================================================"

# ─── pre-flight checks ───────────────────────────────────────────────────────
if ! command -v docker &>/dev/null; then
    echo "[ERROR] docker is not installed or not in PATH."
    exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/dockerfile" ]]; then
    echo "[ERROR] dockerfile not found at ${SCRIPT_DIR}/dockerfile"
    exit 1
fi

if [[ ! -f "${SCRIPT_DIR}/setup_env.sh" ]]; then
    echo "[ERROR] setup_env.sh not found at ${SCRIPT_DIR}/setup_env.sh"
    exit 1
fi

# ─── determine whether a rebuild is needed ───────────────────────────────────

# Extract the QAIRT version declared in the dockerfile (ARG QAIRT_VERSION=x.x.x.x)
DOCKERFILE_QAIRT_VERSION=$(grep -oP '(?<=ARG QAIRT_VERSION=)\S+' "${SCRIPT_DIR}/dockerfile" | head -1)

IMAGE_EXISTS=false
if docker image inspect "${IMAGE_NAME}:latest" &>/dev/null; then
    IMAGE_EXISTS=true
fi

NEED_REBUILD=false
REBUILD_REASON=""

if [[ "${FORCE_REBUILD}" == true ]]; then
    NEED_REBUILD=true
    REBUILD_REASON="--rebuild flag specified"
elif [[ "${IMAGE_EXISTS}" == false ]]; then
    NEED_REBUILD=true
    REBUILD_REASON="image does not exist"
elif [[ -n "${DOCKERFILE_QAIRT_VERSION}" ]]; then
    IMAGE_QAIRT_VERSION=$(docker inspect --format '{{index .Config.Labels "qairt_version"}}' "${IMAGE_NAME}:latest" 2>/dev/null || true)
    if [[ "${IMAGE_QAIRT_VERSION}" != "${DOCKERFILE_QAIRT_VERSION}" ]]; then
        NEED_REBUILD=true
        REBUILD_REASON="QAIRT version changed (${IMAGE_QAIRT_VERSION:-unknown} → ${DOCKERFILE_QAIRT_VERSION})"
    fi
fi

# ─── step 1: stop and remove existing container ──────────────────────────────
# Always done so a fresh container can be started with the same name.
# Image is only removed below if a rebuild is actually needed.
echo ""
echo "[1/4] Checking for existing container '${CONTAINER_NAME}' ..."
if docker ps -a --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
    echo "      Found existing container. Stopping and removing it..."
    docker stop "${CONTAINER_NAME}" &>/dev/null || true
    docker rm   "${CONTAINER_NAME}" &>/dev/null || true
    echo "      Existing container removed."
else
    echo "      No existing container found."
fi

# ─── step 2: build image (only when needed) ──────────────────────────────────
if [[ "${NEED_REBUILD}" == false ]]; then
    echo ""
    echo "[2/4] Image '${IMAGE_NAME}' (QAIRT ${DOCKERFILE_QAIRT_VERSION}) is up to date — skipping build."
    echo "      Use --rebuild to force a new build."
else
    echo ""
    echo "[2/4] Rebuild reason : ${REBUILD_REASON}"
    if [[ "${IMAGE_EXISTS}" == true ]]; then
        echo "      Removing existing image '${IMAGE_NAME}:latest' to free disk space ..."
        docker rmi "${IMAGE_NAME}:latest" || true
    fi
    echo "      Building Docker image '${IMAGE_NAME}' (QAIRT ${DOCKERFILE_QAIRT_VERSION}) ..."
    echo "      (This downloads QAIRT SDK + Android NDK — may take 10-20 min)"
    echo ""
    docker build ${NO_CACHE} \
        --build-arg QAIRT_VERSION="${DOCKERFILE_QAIRT_VERSION}" \
        -t "${IMAGE_NAME}" \
        -f "${SCRIPT_DIR}/dockerfile" \
        "${SCRIPT_DIR}"
    echo ""
    echo "[2/4] Image '${IMAGE_NAME}' built successfully."
fi

# ─── step 3: run new container ───────────────────────────────────────────────
echo ""
echo "[3/4] Starting container '${CONTAINER_NAME}' ..."
docker run \
    --net host \
    --detach \
    --interactive \
    --tty \
    --name "${CONTAINER_NAME}" \
    --mount type=bind,source="${MOUNT_SOURCE}",target="${MOUNT_TARGET}" \
    "${IMAGE_NAME}:latest"

echo ""
echo "============================================================"
echo "  Container '${CONTAINER_NAME}' is running."
echo "  Opening shell — type 'exit' to leave the container."
echo "============================================================"
echo ""

# ─── step 4: open interactive shell inside the container ─────────────────────
docker exec -it --workdir "${QIDK_CONTAINER_PATH}" "${CONTAINER_NAME}" /bin/bash

echo ""
echo "============================================================"
echo "  Exited container shell. Container is still running."
echo ""
echo "  Re-enter  : docker exec -it ${CONTAINER_NAME} /bin/bash"
echo "  Stop      : docker stop ${CONTAINER_NAME}"
echo "  Remove    : docker rm ${CONTAINER_NAME}"
echo "  Rebuild   : ./run_qairt_docker.sh --rebuild"
echo "============================================================"
