###
# File: 10_download.sh
# Project: VORBIS
# File Created: Wednesday, 9th June 2021 12:47:21 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:47:56 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing vorbis (${VORBIS}) ****"
mkdir -p /tmp/vorbis
curl -Lf \
    http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/vorbis
[[ $? -gt 0 ]] && exit 1
