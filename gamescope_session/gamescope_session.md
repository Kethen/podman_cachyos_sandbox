It is somewhat possible to launch full gamescope session from this container. However, a few things has to be prepared:

1. Create a wayland session that runs `launch.sh`
2. Remove `$DISP` and `$MODS` in `launch.sh`
3. For controller hotplug to work, udev has to be working, remove `--cap-add=all` in `launch.sh` and replace it with `--userns keep-id:uid=1000,gid=1000,size=1000`, see https://github.com/containers/toolbox/issues/1203#issuecomment-3740950038
4. Install and launch seatd with seatd socket accessible by your user `sudo seatd -u <user name> -g <group name>`, or run that as a systemd service on boot
5. Clear `script` and write `steam -steamdeck` into `script` then run `launch.sh` once on a normal desktop environment, login and go into big picture mode once. This is not required if gamescope session is used with other gamescope UIs.
6. Clear `script` and write `/usr/share/gamescope-session-plus/gamescope-session-plus <your app>` into `script`. In the case of steam, it'd be `/usr/share/gamescope-session-plus/gamescope-session-plus steam`
