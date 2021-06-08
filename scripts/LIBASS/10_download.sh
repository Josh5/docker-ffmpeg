###
# File: 10_download.sh
# Project: LIBASS
# File Created: Tuesday, 8th June 2021 11:48:14 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:21:17 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing libass (${LIBASS}) ****"
mkdir -p /tmp/libass
curl -Lf \
    https://github.com/libass/libass/archive/${LIBASS}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/libass
[[ $? -gt 0 ]] && exit 1
