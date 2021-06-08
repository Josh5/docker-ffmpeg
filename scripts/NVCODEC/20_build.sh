###
# File: 20_build.sh
# Project: NVCODEC
# File Created: Tuesday, 8th June 2021 11:25:44 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:55:39 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

if ! uname -m | grep -q x86; then
    echo "Arch is not x86. Ignoring"
    mkdir -p /tmp/ffnvcodec
    echo "echo 'ffnvcodec is not compiled for this arch ($(uname -m))...'" > /tmp/ffnvcodec/install-cmd.sh;
    exit 0;
fi

echo "**** compiling ffnvcodec ****"
cd /tmp/ffnvcodec
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/ffnvcodec/install-cmd.sh
cd /tmp/ffnvcodec && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
