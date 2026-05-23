FROM fedora:43

# gpu drivers
RUN dnf install -y mesa-dri-drivers mesa-dri-drivers.i686 mesa-vulkan-drivers mesa-vulkan-drivers.i686

# rpm fusion
RUN dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# codecs
RUN dnf swap -y ffmpeg-free ffmpeg --allowerasing
RUN dnf swap -y mesa-va-drivers mesa-va-drivers-freeworld
RUN dnf swap -y mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
RUN dnf swap -y mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
RUN dnf swap -y mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686

# debug
RUN dnf install -y lxterminal pipewire-utils pavucontrol libva-utils vulkan-tools glx-utils less strace ncurses file helvum nano Thunar vim

# steam
RUN dnf install -y steam util-linux
RUN sed -i 's/"$(id -u)" == "0"/"$(id -u)" == "1"/' /usr/lib/steam/bin_steam.sh

# misc
RUN dnf install -y mangohud

# fonts
RUN dnf install -y google-noto-fonts-all

# VR
RUN dnf install -y --enablerepo=updates-testing wivrn
RUN setcap -r /usr/bin/wivrn-server
RUN mv /usr/bin/wivrn-server /usr/bin/wivrn-server-orig
RUN echo '#!/bin/bash' > /usr/bin/wivrn-server
RUN echo '/usr/bin/wivrn-server-orig --no-publish-service "$@"' >> /usr/bin/wivrn-server
RUN chmod 755 /usr/bin/wivrn-server
RUN dnf install -y opencomposite
RUN dnf install -y cargo git gcc openxr-devel
RUN cargo install --git https://github.com/galister/motoc.git
RUN cp /root/.cargo/bin/motoc /usr/bin/motoc
RUN chmod 755 /usr/bin/motoc

# bottles
RUN dnf install -y bottles

# random machine-id
RUN dd if=/dev/random bs=1 count=16 | xxd -p > /etc/machine-id
