#!/bin/bash

set -xe

script_dir=$(realpath "$0")
script_dir=$(dirname "$script_dir")
cd "$script_dir"

source ./includes/xdg.include
source ./includes/display.include
source ./includes/audio.include
source ./includes/dev.include
source ./includes/fs.include
source ./includes/mods.include
source ./includes/deck_sdl.include
#source ./includes/dbus.include

echo $XDG
echo $DISP
echo $AUDIO
echo $DEV_MOUNT
echo $MOUNT
echo $MODS
echo $DECK_SDL
echo $DBUS

TAG_NAME="podman_cachyos_sandbox"

if [ "$UPDATE_IMAGE" == "true" ]
then
	podman image rm $TAG_NAME || true
fi

if ! podman image exists $TAG_NAME
then
	podman image build --no-cache --layers=false -f Dockerfile -t $TAG_NAME
fi

bash -c "
set -xe
podman run \
	--rm -it \
	--ulimit host \
	--security-opt seccomp=unconfined \
	--security-opt label=disable \
	--ipc=host \
	`#--userns keep-id:uid=1000,gid=1000,size=1000` \
	--cap-add=all \
	--net=host \
	--tz=local \
	--tmpfs=/run:mode=0777 \
	--tmpfs=/tmp:mode=0777 \
	$XDG \
	$DISP \
	$AUDIO \
	$DEV_MOUNT \
	$MOUNT \
	$MODS \
	$DECK_SDL \
	$DBUS \
	-v ./script:/script:ro \
	--entrypoint /bin/bash \
	$TAG_NAME \
	/script
"

source ./includes/mods_cleanup.include
#source ./includes/dbus_cleanup.include
