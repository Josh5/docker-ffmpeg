###
# File: 20_build.sh
# Project: FONTCONFIG
# File Created: Tuesday, 8th June 2021 11:38:16 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:21:14 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/fontconfig
    echo "echo 'fontconfig is not compiled for this arch ($(uname -m))...'" > /tmp/fontconfig/install-cmd.sh;
    exit 0;
fi

echo "**** pre-installing freetype ****"
if [[ ! -f /tmp/freetype/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/freetype to be built first"
    exit 1;
fi
cd /tmp/freetype
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** cleanup pre-install ****"
cd /
rm -rf /tmp/freetype
[[ $? -gt 0 ]] && exit 1

echo "**** compiling fontconfig ****"
cd /tmp/fontconfig
./configure \
    --disable-static \
    --enable-shared 
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/fontconfig/install-cmd.sh
cd /tmp/freetype && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/fontconfig && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
