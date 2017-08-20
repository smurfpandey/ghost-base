#!/usr/bin/env bash

set -Eeuo pipefail

rootDir=$( cd "$(dirname "$0")" ; pwd -P )
source "${rootDir}/../scripts/functions.sh"

if [ $# -eq 0 ]; then
    print_error "Usage: update.sh <service>"
    exit 1
fi

serviceId="${1}"
serviceDir="${rootDir}/${serviceId}"

if [ ! -f "${serviceDir}/Dockerfile" ]; then
    print_error "Dockerfile for service '${serviceId}' is missing"
    exit 1;
fi

username="noiselabs"
image="noiselabs/${serviceId}:latest"

pwd=$(pwd)
cd ${serviceDir}
docker build -t ${image} .
# Tag and push the image to Docker Hub
docker login -u ${username}
docker tag ${image} "${username}/${image}"
docker push ${image}
cd ${pwd}