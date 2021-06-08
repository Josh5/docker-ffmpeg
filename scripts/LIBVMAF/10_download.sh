###
# File: 10_download.sh
# Project: LIBVMAF
# File Created: Wednesday, 9th June 2021 1:01:37 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:02:14 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing vmaf (${LIBVMAF}) ****"
mkdir -p /tmp/vmaf
git clone \
    --branch ${LIBVMAF} \
    https://github.com/Netflix/vmaf.git \
    /tmp/vmaf;
[[ $? -gt 0 ]] && exit 1
