###
# File: 20_build.sh
# Project: LIBDRM
# File Created: Wednesday, 9th June 2021 12:39:20 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:42:55 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/libdrm
    echo "echo 'libdrm is not compiled for this arch ($(uname -m))...'" > /tmp/libdrm/install-cmd.sh;
    exit 0;
fi

echo "**** compiling libdrm ****"
cd /tmp/libdrm
meson builddir/
ninja -vC builddir/
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/libdrm/install-cmd.sh
cd /tmp/libdrm && ninja -vC builddir/ install
if [ $? -gt 0 ]; then exit 1; fi
EOF
