It is somewhat possible to launch full gamescope session from this container. However, a few things has to be prepared:

#### First launch setup

1. Create a new directory and copy `launch.sh`, `script` and `includes` from this repository.
2. Remove the following lines in `launch.sh`

```
source ./includes/mods.include
$DISP
$MODS
source ./includes/mods_cleanup.include
```

3. For controller hotplug to work, udev has to be working, remove `--cap-add=all` in `launch.sh` and replace it with `--userns keep-id:uid=1000,gid=1000,size=1000`, see https://github.com/containers/toolbox/issues/1203#issuecomment-3740950038
4. Install and launch seatd with seatd socket accessible by your user `sudo seatd -u <user name> -g <group name>`
5. Clear `script` and write `steam -steamdeck` into `script` then run `launch.sh` once on a normal desktop environment, login and go into big picture mode once. This is not required if gamescope session is used with other gamescope UIs.
6. Clear `script` and write `/usr/share/gamescope-session-plus/gamescope-session-plus <your app>` into `script`. In the case of steam, it'd be `/usr/share/gamescope-session-plus/gamescope-session-plus steam`. 'ctrl + alt + f3' to switch to tty3, login there, then run `launch.sh`. Once launched, you can use 'ctrl + alt + f*' to go back to your desktop.

#### Subsequent launches

1. Install and launch seatd with seatd socket accessible by your user `sudo seatd -u <user name> -g <group name>`
2. 'ctrl + alt + f3' to switch to tty3, login there, then run `launch.sh`. Once launched, you can use 'ctrl + alt + f*' to go back to your desktop

#### Start steam session from your display manager

1. Perform all first launch setup step to make sure everything is working.
2. Copy `gamescope_session/seatd.service` from this repository to `/etc/systemd/system`, modify the `-u` `-g` flag to your user and group name
3. Run the following commands to enable and start the service

```
systemctl daemon-reload
systemctl enable --now seatd.service
```

4. Copy `gamescope_session/gamescope_session.desktop` from this repository to `/usr/share/wayland-sessions/`, modify `Exec=` line to `Exec=/bin/bash -c 'cd <your container directory>; bash launch.sh'`. You can also modify the session name on the `Name=` line.
5. Logout and pick your new session.
