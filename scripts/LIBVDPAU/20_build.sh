###
# File: 20_build.sh
# Project: LIBVDPAU
# File Created: Wednesday, 9th June 2021 1:29:19 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:31:15 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/libvdpau
    echo "echo 'libvdpau is not compiled for this arch ($(uname -m))...'" > /tmp/libvdpau/install-cmd.sh;
    exit 0;
fi

echo "**** compiling libvdpau ****"
cd /tmp/libvdpau
./autogen.sh
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/libvdpau/install-cmd.sh
cd /tmp/libvdpau && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
