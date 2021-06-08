###
# File: 20_build.sh
# Project: LIBVMAF
# File Created: Wednesday, 9th June 2021 1:03:09 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:05:09 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/libvmaf
    echo "echo 'libvmaf is not compiled for this arch ($(uname -m))...'" > /tmp/libvmaf/install-cmd.sh;
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

echo "**** compiling libvmaf ****"
cd /tmp/vmaf/libvmaf
meson build --buildtype release
ninja -vC build

echo "**** cleanup pre-install ****"
cd /
rm -rf /tmp/nasm
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/vmaf/install-cmd.sh
cd /tmp/nasm && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/vmaf/libvmaf && ninja -vC build/ install
if [ $? -gt 0 ]; then exit 1; fi
EOF
