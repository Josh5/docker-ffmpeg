###
# File: 10_download.sh
# Project: X265
# File Created: Wednesday, 9th June 2021 10:15:21 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 10:16:25 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing x265 (${X265}) ****"
mkdir -p /tmp/x265
curl -Lf \
    https://github.com/videolan/x265/archive/Release_${X265}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/x265
[[ $? -gt 0 ]] && exit 1
