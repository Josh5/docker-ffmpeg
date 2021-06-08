###
# File: 10_download.sh
# Project: THEORA
# File Created: Wednesday, 9th June 2021 12:51:23 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:51:46 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing theora (${THEORA}) ****"
mkdir -p /tmp/theora
curl -Lf \
    http://downloads.xiph.org/releases/theora/libtheora-${THEORA}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/theora
[[ $? -gt 0 ]] && exit 1
