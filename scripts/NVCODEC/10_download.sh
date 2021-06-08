###
# File: 10_download.sh
# Project: NVCODEC
# File Created: Tuesday, 8th June 2021 11:46:00 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:21:19 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing ffnvcodec (${NVCODEC}) ****"
mkdir -p /tmp/ffnvcodec
git clone \
    --branch ${NVCODEC} \
    --depth 1 https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
    /tmp/ffnvcodec;
[[ $? -gt 0 ]] && exit 1
