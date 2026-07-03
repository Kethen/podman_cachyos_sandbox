FROM docker.io/cachyos/cachyos-v3:latest
RUN pacman -Sy

# video driver & codec
RUN pacman -S --noconfirm mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon vulkan-intel lib32-vulkan-intel
#RUN pacman -S --noconfirm mesa-git lib32-mesa-git

# debugging & libraries
RUN pacman -S --noconfirm sdl3 sdl2-compat
RUN pacman -S --noconfirm pavucontrol helvum lxterminal evtest nano glmark2 libva-utils firefox thunar kate libinput-tools
RUN pacman -S --noconfirm hidapi
RUN pacman -S --noconfirm vulkan-tools mesa-utils wayland-utils

# mangohud
RUN pacman -S --noconfirm mangohud lib32-mangohud

# steam
RUN pacman -S --noconfirm gamescope steam
RUN sed -i 's/"$(id -u)" == "0"/"$(id -u)" == "1"/' /usr/lib/steam/bin_steam.sh

# fonts
RUN pacman -S --noconfirm noto-fonts noto-fonts-cjk noto-fonts-emoji noto-fonts-extra

# git
RUN pacman -S --noconfirm git

# VR
#RUN git clone https://aur.archlinux.org/wivrn-server.git; cd wivrn-server; sed -i 's/"libpipewire"/"libpipewire" "libpulse"/' PKGBUILD; sed -i 's/-DWIVRN_USE_VAAPI=ON/-DWIVRN_USE_VAAPI=ON -DWIVRN_USE_PULSEAUDIO=ON/' PKGBUILD; env EUID=1 makepkg -sir --noconfirm; setcap -r /usr/bin/wivrn-server; cd ..; rm -r wivrn-server
RUN pacman -S --noconfirm pipewire-audio # seems to be missing from wivrn deps, required for virtual audio device
RUN git clone https://aur.archlinux.org/wivrn-server.git; cd wivrn-server; env EUID=1 makepkg -sir --noconfirm; setcap -r /usr/bin/wivrn-server; cd ..; rm -r wivrn-server
RUN mv /usr/bin/wivrn-server /usr/bin/wivrn-server-orig
RUN echo '#!/bin/bash' > /usr/bin/wivrn-server
RUN echo '/usr/bin/wivrn-server-orig --no-publish-service "$@"' >> /usr/bin/wivrn-server
RUN chmod 755 /usr/bin/wivrn-server
#RUN pacman -S --noconfirm cargo openxr
#RUN cargo install --git https://github.com/galister/motoc.git
#RUN cp /root/.cargo/bin/motoc /usr/bin/motoc
#RUN chmod 755 /usr/bin/motoc
RUN pacman -S --noconfirm android-tools
#RUN git clone https://aur.archlinux.org/xrizer.git; cd xrizer; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r xrizer
RUN git clone https://aur.archlinux.org/xrizer-git.git; cd xrizer-git; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r xrizer-git
#RUN git clone https://aur.archlinux.org/xrizer-git.git; cd xrizer-git; sed -i 's#url="https://github.com/Supreeeme/xrizer"#url="https://github.com/Kethen/xrizer"#' PKGBUILD; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r xrizer-git
RUN git clone https://aur.archlinux.org/opencomposite-git.git; cd opencomposite-git; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r opencomposite-git
RUN git clone https://aur.archlinux.org/motoc-git.git; cd motoc-git; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r motoc-git

# bottles
RUN git clone https://aur.archlinux.org/fvs2.git; cd fvs2; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r fvs2
RUN git clone https://aur.archlinux.org/bottles.git; cd bottles; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r bottles
RUN pacman -S --noconfirm protonup-qt

# Sunshine
RUN pacman -S --noconfirm sunshine

# machine id
RUN pacman -S --noconfirm vim
RUN dd if=/dev/random bs=1 count=16 | xxd -p > /etc/machine-id

# wine
RUN pacman -S --noconfirm wine winetricks wine-mono

# qemu
RUN pacman -S --noconfirm qemu-full

# gamescope session
RUN git clone https://aur.archlinux.org/gamescope-session-git.git; cd gamescope-session-git; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r gamescope-session-git
RUN git clone https://aur.archlinux.org/gamescope-session-steam-git.git; cd gamescope-session-steam-git; env EUID=1 makepkg -sir --noconfirm; cd ..; rm -r gamescope-session-steam-git
# undo gamescope cap
#RUN setcap -r /usr/bin/gamescope

# 32 bit wine pulseaudio
RUN pacman -S --noconfirm lib32-libpulse

# clean package cache
RUN rm /var/cache/pacman/pkg/*
