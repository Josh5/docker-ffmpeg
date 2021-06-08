###
# File: 20_build.sh
# Project: NASM
# File Created: Wednesday, 9th June 2021 1:33:17 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:33:46 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling nasm ****"
cd /tmp/nasm
./autogen.sh
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/nasm/install-cmd.sh
cd /tmp/nasm && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
