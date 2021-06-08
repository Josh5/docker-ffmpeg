###
# File: 20_build.sh
# Project: LIBFRIBIDI
# File Created: Wednesday, 9th June 2021 12:17:07 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:33:59 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling fribidi ****"
cd /tmp/fribidi
./autogen.sh
./configure \
    --disable-static \
    --enable-shared
make -j 1
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/fribidi/install-cmd.sh
cd /tmp/fribidi && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
