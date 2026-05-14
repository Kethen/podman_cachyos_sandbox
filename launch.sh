set -xe

script_dir=$(realpath "$0")
script_dir=$(dirname ${script_dir})
cd "$script_dir"

source ./includes/display.include
source ./includes/audio.include
source ./includes/dev.include
source ./includes/fs.include
source ./includes/mods.include
source ./includes/xdg.include

echo $DISP
echo $AUDIO
echo $DEV_MOUNT
echo $MOUNT
echo $MODS

TAG_NAME="podman_fedora_sandbox"

if [ "$UPDATE_IMAGE" == "true" ]
then
	podman image rm $TAG_NAME || true
fi

if ! podman image exists $TAG_NAME
then
	podman image build --no-cache -f Dockerfile -t $TAG_NAME
fi

bash -c "
set -xe
podman run \
	--rm -it \
	--ulimit host \
	--security-opt seccomp=unconfined \
	--security-opt label=disable \
	--ipc=host \
	`#--userns keep-id:uid=1000,gid=1000` \
	--cap-add=all \
	--net=host \
	$DISP \
	$AUDIO \
	$DEV_MOUNT \
	$MOUNT \
	$MODS \
	$XDG \
	-v ./script:/script:ro \
	--entrypoint /bin/bash \
	$TAG_NAME \
	/script
"

source ./includes/mods_cleanup.include
