###
# File: 20_build.sh
# Project: LIBVA
# File Created: Wednesday, 9th June 2021 12:44:56 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:45:50 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/libva
    echo "echo 'libva is not compiled for this arch ($(uname -m))...'" > /tmp/libva/install-cmd.sh;
    exit 0;
fi

echo "**** compiling libva ****"
cd /tmp/libva
./autogen.sh
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/libva/install-cmd.sh
cd /tmp/libva && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
