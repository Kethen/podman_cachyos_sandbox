FROM docker.io/cachyos/cachyos-v3:latest
RUN pacman -Sy
RUN pacman -S --noconfirm cachyos/mesa cachyos/lib32-mesa cachyos/vulkan-radeon cachyos/lib32-vulkan-radeon cachyos/vulkan-intel cachyos/lib32-vulkan-intel
#RUN pacman -S --noconfirm cachyos-v3/mesa-git cachyos-v3/lib32-mesa-git 
RUN pacman -S --noconfirm extra/pavucontrol extra/helvum cachyos-extra-v3/lxterminal cachyos-extra-v3/evtest cachyos-core-v3/nano cachyos-extra-v3/glmark2 cachyos-extra-v3/libva-utils cachyos-extra-v3/firefox
RUN pacman -S --noconfirm cachyos-extra-v3/hidapi
RUN pacman -S --noconfirm cachyos-extra-v3/sdl3 cachyos-extra-v3/sdl2-compat
RUN pacman -S --noconfirm cachyos-v3/gamescope multilib/steam
RUN pacman -S --noconfirm extra/noto-fonts extra/noto-fonts-cjk extra/noto-fonts-emoji extra/noto-fonts-extra

RUN pacman -S --noconfirm cachyos-extra-v3/git; git clone https://aur.archlinux.org/wivrn-server.git; cd wivrn-server; env EUID=1 makepkg -si --noconfirm; setcap -r /usr/bin/wivrn-server
