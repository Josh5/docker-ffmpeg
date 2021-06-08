###
# File: 20_build.sh
# Project: LIBASS
# File Created: Tuesday, 8th June 2021 11:49:14 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:31:30 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** pre-installing freetype ****"
echo
echo
if [[ ! -f /tmp/freetype/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/freetype to be built first"
    exit 1;
fi
cd /tmp/freetype
cat ./install-cmd.sh
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** pre-installing fontconfig ****"
echo
echo
if [[ ! -f /tmp/fontconfig/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/fontconfig to be built first"
    exit 1;
fi
cd /tmp/fontconfig
cat ./install-cmd.sh
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** pre-installing fribidi ****"
echo
echo
if [[ ! -f /tmp/fribidi/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/fribidi to be built first"
    exit 1;
fi
cd /tmp/fribidi
cat ./install-cmd.sh
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** compiling libass ****"
cd /tmp/libass
./autogen.sh
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

echo "**** cleanup pre-install ****"
cd /
rm -rf /tmp/freetype
[[ $? -gt 0 ]] && exit 1
rm -rf /tmp/fontconfig
[[ $? -gt 0 ]] && exit 1
rm -rf /tmp/fribidi
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/libass/install-cmd.sh
cd /tmp/freetype && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/fontconfig && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/fribidi && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/libass && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
