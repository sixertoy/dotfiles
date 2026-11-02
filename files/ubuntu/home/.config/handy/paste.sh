#!/bin/bash
exec > /tmp/handy-debug.log 2>&1
set -x

# 1. Copier dans le presse-papiers
echo -n "$1" | wl-copy

# 2. Pause de synchronisation
sleep 0.1

# 3. Déclarer le socket
export YDOTOOL_SOCKET="/tmp/.ydotool_socket"

# 4. Simuler Ctrl(29) + V(47) en signaux bruts (Appui Ctrl, Appui V, Relâche V, Relâche Ctrl)
# ydotool key 29:1 47:1 47:0 29:0
ydotool key ctrl+v
