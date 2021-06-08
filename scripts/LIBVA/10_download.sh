###
# File: 10_download.sh
# Project: LIBVA
# File Created: Wednesday, 9th June 2021 12:44:19 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:44:48 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing libva (${LIBVA}) ****"
mkdir -p /tmp/libva
curl -Lf \
    https://github.com/intel/libva/archive/${LIBVA}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/libva; \ 
[[ $? -gt 0 ]] && exit 1
