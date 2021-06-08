###
# File: 20_build.sh
# Project: LIBDAV1D
# File Created: Wednesday, 9th June 2021 12:55:58 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:16:37 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/dav1d
    echo "echo 'dav1d is not compiled for this arch ($(uname -m))...'" > /tmp/dav1d/install-cmd.sh;
    exit 0;
fi

echo "**** pre-installing nasm ****"
echo
echo
if [[ ! -f /tmp/nasm/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/nasm to be built first"
    exit 1;
fi
cd /tmp/nasm
cat ./install-cmd.sh
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** compiling dav1d ****" \
cd /tmp/dav1d
mkdir -p build
cd build
meson --bindir="/usr/local/bin" ..
ninja

echo "**** cleanup pre-install ****"
cd /
rm -rf /tmp/nasm
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/dav1d/install-cmd.sh
cd /tmp/nasm && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

mkdir -p /tmp/dav1d/build
cd /tmp/dav1d/build
meson --bindir="/usr/local/bin" ..
ninja install
if [ $? -gt 0 ]; then exit 1; fi
EOF
