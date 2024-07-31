#!/usr/bin/env bash

HAOS_VERSION="9.4"
HAOS_IMAGE_NAME="haos_${HAOS_VERSION}.qcow2"
PROJECT_DIR=`pwd`
IMAGE_CACHE=$HOME/.terraform/image_cache

if [ ! -d $IMAGE_CACHE ]; then
  mkdir -p $IMAGE_CACHE
fi


echo "Image Cache Location: "
echo $IMAGE_CACHE
echo "Project Directory: "
echo $PROJECT_DIR
echo

cd $IMAGE_CACHE

if [ -e ${HAOS_IMAGE_NAME} ]
then
  echo "${HAOS_IMAGE_NAME} image found. Not downloading again."
  exit 0
else
  echo "No ${HAOS_IMAGE_NAME} image found. Downloading..."
fi

wget https://github.com/home-assistant/operating-system/releases/download/$HAOS_VERSION/haos_ova-$HAOS_VERSION.qcow2.xz -O $HAOS_IMAGE_NAME.xz
unxz -v $HAOS_IMAGE_NAME.xz
cd $PROJECT_DIR