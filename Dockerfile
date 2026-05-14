FROM docker.io/cachyos/cachyos-v3:latest
RUN pacman -Sy

# video driver & codec
RUN pacman -S --noconfirm cachyos/mesa cachyos/lib32-mesa cachyos/vulkan-radeon cachyos/lib32-vulkan-radeon cachyos/vulkan-intel cachyos/lib32-vulkan-intel
#RUN pacman -S --noconfirm cachyos-v3/mesa-git cachyos-v3/lib32-mesa-git 

# debugging & libraries
RUN pacman -S --noconfirm extra/pavucontrol extra/helvum cachyos-extra-v3/lxterminal cachyos-extra-v3/evtest cachyos-core-v3/nano cachyos-extra-v3/glmark2 cachyos-extra-v3/libva-utils cachyos-extra-v3/firefox cachyos-extra-v3/thunar cachyos-extra-v3/kate
RUN pacman -S --noconfirm cachyos-extra-v3/hidapi
RUN pacman -S --noconfirm cachyos-extra-v3/sdl3 cachyos-extra-v3/sdl2-compat
RUN pacman -S --noconfirm cachyos-extra-v3/vulkan-tools cachyos-extra-v3/mesa-utils cachyos-extra-v3/wayland-utils

# mangohud
RUN pacman -S --noconfirm cachyos-extra-v3/mangohud multilib/lib32-mangohud

# steam
RUN pacman -S --noconfirm cachyos-v3/gamescope multilib/steam
RUN sed -i 's/"$(id -u)" == "0"/"$(id -u)" == "1"/' /usr/lib/steam/bin_steam.sh

# fonts
RUN pacman -S --noconfirm extra/noto-fonts extra/noto-fonts-cjk extra/noto-fonts-emoji extra/noto-fonts-extra

# git
RUN pacman -S --noconfirm cachyos-extra-v3/git

# VR
RUN git clone https://aur.archlinux.org/wivrn-server.git; cd wivrn-server; env EUID=1 makepkg -si --noconfirm; setcap -r /usr/bin/wivrn-server
RUN mv /usr/bin/wivrn-server /usr/bin/wivrn-server-orig
RUN echo '#!/bin/bash' > /usr/bin/wivrn-server
RUN echo '/usr/bin/wivrn-server-orig --no-publish-service "$@"' >> /usr/bin/wivrn-server
RUN chmod 755 /usr/bin/wivrn-server
RUN pacman -S --noconfirm cachyos-extra-v3/cargo cachyos-extra-v3/openxr
RUN cargo install --git https://github.com/galister/motoc.git
RUN cp /root/.cargo/bin/motoc /usr/bin/motoc
RUN chmod 755 /usr/bin/motoc
RUN pacman -S --noconfirm cachyos-extra-v3/android-tools
RUN git clone https://aur.archlinux.org/xrizer.git; cd xrizer; env EUID=1 makepkg -si --noconfirm
RUN git clone https://aur.archlinux.org/opencomposite-git.git; cd opencomposite-git; env EUID=1 makepkg -si --noconfirm

# bottles
RUN git clone https://aur.archlinux.org/fvs2.git; cd fvs2; env EUID=1 makepkg -si --noconfirm
RUN git clone https://aur.archlinux.org/bottles.git; cd bottles; env EUID=1 makepkg -si --noconfirm
RUN pacman -S --noconfirm cachyos/protonup-qt

# Sunshine
RUN pacman -S --noconfirm cachyos/sunshine

# machine id
RUN pacman -S --noconfirm vim
RUN dd if=/dev/random bs=1 count=32 | xxd -p > /etc/machine-id
