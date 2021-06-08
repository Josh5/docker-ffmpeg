###
# File: 10_download.sh
# Project: KVAZAAR
# File Created: Wednesday, 9th June 2021 12:19:01 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:22:03 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing kvazaar (${KVAZAAR}) ****"
mkdir -p /tmp/kvazaar
curl -Lf \
    https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/kvazaar
[[ $? -gt 0 ]] && exit 1
