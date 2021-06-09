###
# File: 20_build.sh
# Project: X265
# File Created: Wednesday, 9th June 2021 10:15:49 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 6:32:11 pm
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling x265 (ARCH: $(uname -m)) ****"
if uname -m | grep -q x86; then
    # x86
    cd /tmp/x265/build/linux
    ./multilib.sh
    [[ $? -gt 0 ]] && exit 1
    make -C 8bit install
    [[ $? -gt 0 ]] && exit 1
elif uname -m | grep -q aarch64; then
    # arm64
    cd /tmp/x265/build/linux
    export CXXFLAGS="-fPIC"
    ./multilib.sh
    [[ $? -gt 0 ]] && exit 1
    make -C 8bit install
    [[ $? -gt 0 ]] && exit 1
elif uname -m | grep -q armv7l; then
    # armv7
    cd /tmp/x265/build/linux
    curl -fL \
        https://sources.debian.org/data/main/x/x265/3.4-2/debian/patches/0001-Fix-arm-flags.patch \
        > arm.patch
    patch ../../source/CMakeLists.txt < arm.patch
    cmake \
        -D ENABLE_ASSEMBLY=OFF \
        -D ENABLE_CLI=OFF \
        -G "Unix Makefiles" ../../source
    make
    [[ $? -gt 0 ]] && exit 1
    make install
    [[ $? -gt 0 ]] && exit 1
fi

# Write install script (different for different arch)
# x86
if uname -m | grep -q x86; then
cat << 'EOF' > /tmp/x265/install-cmd.sh
cd /tmp/x265/build/linux
make -C 8bit install
if [ $? -gt 0 ]; then exit 1; fi
EOF
fi
# arm64
if uname -m | grep -q aarch64; then
cat << 'EOF' > /tmp/x265/install-cmd.sh
cd /tmp/x265/build/linux
export CXXFLAGS="-fPIC"
make -C 8bit install
if [ $? -gt 0 ]; then exit 1; fi
EOF
fi
# armv7
if uname -m | grep -q armv7l; then
cat << 'EOF' > /tmp/x265/install-cmd.sh
cd /tmp/x265/build/linux
make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
fi
