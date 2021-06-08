###
# File: 10_download.sh
# Project: LIBFRIBIDI
# File Created: Wednesday, 9th June 2021 12:16:35 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:17:01 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing fribidi (${LIBFRIBIDI}) ****"
mkdir -p /tmp/fribidi
curl -Lf \
    https://github.com/fribidi/fribidi/archive/v${LIBFRIBIDI}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/fribidi
[[ $? -gt 0 ]] && exit 1
