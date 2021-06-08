###
# File: 10_download.sh
# Project: LAME
# File Created: Wednesday, 9th June 2021 12:36:38 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:37:19 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing lame (${LAME}) ****"
mkdir -p /tmp/lame
curl -Lf \
    http://downloads.sourceforge.net/project/lame/lame/${LAME}/lame-${LAME}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/lame
[[ $? -gt 0 ]] && exit 1
