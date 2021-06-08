###
# File: 10_download.sh
# Project: NASM
# File Created: Wednesday, 9th June 2021 1:32:43 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:34:23 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing nasm (${NASM}) ****"
mkdir -p /tmp/nasm
curl -Lf \
    https://www.nasm.us/pub/nasm/releasebuilds/${NASM}/nasm-${NASM}.tar.bz2 | \
    tar -jx --strip-components=1 -C /tmp/nasm
[[ $? -gt 0 ]] && exit 1
