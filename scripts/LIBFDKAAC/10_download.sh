###
# File: 10_download.sh
# Project: LIBFDKAAC
# File Created: Tuesday, 8th June 2021 11:56:28 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:21:04 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing fdk-aac (${LIBFDKAAC}) ****"
mkdir -p /tmp/fdk-aac
curl -Lf \
    https://github.com/mstorsjo/fdk-aac/archive/v${LIBFDKAAC}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/fdk-aac
[[ $? -gt 0 ]] && exit 1
