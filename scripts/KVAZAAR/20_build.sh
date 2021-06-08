###
# File: 20_build.sh
# Project: KVAZAAR
# File Created: Wednesday, 9th June 2021 12:22:32 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:32:53 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling kvazaar ****"
cd /tmp/kvazaar
./autogen.sh
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/kvazaar/install-cmd.sh
cd /tmp/kvazaar && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
