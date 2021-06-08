###
# File: 10_download.sh
# Project: LIBVDPAU
# File Created: Wednesday, 9th June 2021 1:28:29 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:29:07 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing libvdpau (${LIBVDPAU}) ****"
mkdir -p /tmp/libvdpau
git clone \
    --branch ${LIBVDPAU} \
    --depth 1 https://gitlab.freedesktop.org/vdpau/libvdpau.git \
    /tmp/libvdpau
[[ $? -gt 0 ]] && exit 1
