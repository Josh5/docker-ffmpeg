###
# File: 10_downloads.sh
# Project: LIBAOM
# File Created: Wednesday, 9th June 2021 1:25:08 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:25:25 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing aom (${LIBAOM}) ****"
mkdir -p /tmp/aom
git clone \
    --branch ${LIBAOM} \
    --depth 1 https://aomedia.googlesource.com/aom \
    /tmp/aom
[[ $? -gt 0 ]] && exit 1
