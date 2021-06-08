###
# File: 10_download.sh
# Project: LIBDAV1D
# File Created: Wednesday, 9th June 2021 12:55:49 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:56:37 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing dav1d (${LIBDAV1D}) ****"
mkdir -p /tmp/dav1d
git clone \
    --branch ${LIBDAV1D} \
    --depth 1 https://code.videolan.org/videolan/dav1d.git \
    /tmp/dav1d
[[ $? -gt 0 ]] && exit 1
