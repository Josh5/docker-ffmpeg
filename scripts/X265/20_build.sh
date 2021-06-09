###
# File: 20_build.sh
# Project: X265
# File Created: Wednesday, 9th June 2021 10:15:49 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 10:15:54 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling x265 ****"
if uname -m | grep -q x86; then
    cd /tmp/x265/build/linux
    export MAKEFLAGS="-j$(nproc) "
    ./multilib.sh
    [[ $? -gt 0 ]] && exit 1
    echo
else
    cd /tmp/x265/build/linux
    export CXXFLAGS="-fPIC"
    export MAKEFLAGS="-j$(nproc) "
    ./multilib.sh
    [[ $? -gt 0 ]] && exit 1
    echo
fi

# Write install script
cat << 'EOF' > /tmp/x265/install-cmd.sh
cd /tmp/x265/build/linux && make -C 8bit install
if [ $? -gt 0 ]; then exit 1; fi
EOF
