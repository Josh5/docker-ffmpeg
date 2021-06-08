###
# File: 20_build.sh
# Project: LIBAOM
# File Created: Wednesday, 9th June 2021 1:25:50 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:27:27 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling aom ****"
cd /tmp/aom
rm -rf \
    CMakeCache.txt \
    CMakeFiles
mkdir -p aom_build
cd aom_build
if uname -m | grep -q armv7l; then
    echo "  - build AOM_TARGET_CPU=generic"
    cmake \
        -DAOM_TARGET_CPU=generic \
        -DBUILD_STATIC_LIBS=0 ..
else
    cmake \
        -DBUILD_STATIC_LIBS=0 ..
fi
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/aom/install-cmd.sh
cd /tmp/aom/aom_build && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
