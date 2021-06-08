###
# File: 10_download.sh
# Project: LIBFREETYPE
# File Created: Tuesday, 8th June 2021 11:57:31 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:13:44 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** grabbing freetype (${LIBFREETYPE}) ****"
mkdir -p /tmp/freetype
curl -Lf \
    https://download.savannah.gnu.org/releases/freetype/freetype-${LIBFREETYPE}.tar.gz | \
    tar -zx --strip-components=1 -C /tmp/freetype
[[ $? -gt 0 ]] && exit 1
