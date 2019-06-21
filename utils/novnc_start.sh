#!/bin/bash
#
# ----- start the X11 frame buffer (Xvfb)
# ----- the openbox window manager
# ----- and the x11vnc server
#
DISPLAY=:1
DEPTH=24
GEOMETRY=1280X1024

Xvfb ${DISPLAY} -screen 0 ${GEOMETRY}x${DEPTH} &
sleep 5
openbox-session &
x11vnc -display ${DISPLAY} -nopw -listen localhost -xkb -ncache 10 -ncache_cr -forever &
#
# ----- start up the noVNC server so that browsers
# ----- can connect on the exposed port (6080)
#
cd /home/mentor/noVNC
./utils/launch.sh --vnc localhost:5900
