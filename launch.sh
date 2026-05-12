set -xe

script_dir=$(realpath "$0")
script_dir=$(dirname ${script_dir})
cd "$script_dir"

source ./includes/display.include
source ./includes/audio.include
source ./includes/dev.include
source ./includes/fs.include

echo $DISP
echo $AUDIO
echo $DEV_MOUNT
echo $MOUNT

TAG_NAME="podman_cachyos_sandbox"

if [ "$UPDATE_IMAGE" == "true" ]
then
	podman image rm $TAG_NAME || true
fi

if ! podman image exists $TAG_NAME
then
	podman image build -f Dockerfile -t $TAG_NAME
fi

podman run \
	--rm -it \
	--ulimit host \
	--security-opt seccomp=unconfined \
	--security-opt label=disable \
	--ipc=host \
	--userns keep-id:uid=1000,gid=1000 \
	$DISP \
	$AUDIO \
	$DEV_MOUNT \
	$MOUNT \
	-v ./script:/script:ro \
	--entrypoint /bin/bash \
	$TAG_NAME \
	/script
