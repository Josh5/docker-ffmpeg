###
# File: 10_download.sh
# Project: FONTCONFIG
# File Created: Wednesday, 9th June 2021 12:04:42 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:14:03 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing ffnvcodec (${FONTCONFIG}) ****"
mkdir -p /tmp/fontconfig
curl -Lf \
    https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/fontconfig
[[ $? -gt 0 ]] && exit 1
