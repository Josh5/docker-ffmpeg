###
# File: 20_build.sh
# Project: LIBFREETYPE
# File Created: Tuesday, 8th June 2021 11:57:37 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:33:41 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling freetype ****"
cd /tmp/freetype
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/freetype/install-cmd.sh
cd /tmp/freetype && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
