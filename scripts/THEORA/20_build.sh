###
# File: 20_build.sh
# Project: THEORA
# File Created: Wednesday, 9th June 2021 12:51:52 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:06:20 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** pre-installing ogg ****"
if [[ ! -f /tmp/ogg/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/ogg to be built first"
    exit 1;
fi
cd /tmp/ogg
cat ./install-cmd.sh
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** pre-installing vorbis ****"
if [[ ! -f /tmp/vorbis/install-cmd.sh ]]; then
    echo "ERROR! requires /tmp/vorbis to be built first"
    exit 1;
fi
cd /tmp/vorbis
cat ./install-cmd.sh
. ./install-cmd.sh
[[ $? -gt 0 ]] && exit 1

echo "**** compiling theora ****"
cd /tmp/theora
cp /usr/share/automake-1.15/config.guess config.guess
cp /usr/share/automake-1.15/config.sub config.sub
curl -fL \
    'https://gitlab.xiph.org/xiph/theora/-/commit/7288b539c52e99168488dc3a343845c9365617c8.diff' \
    > png.patch
patch ./examples/png2theora.c < png.patch

./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

echo "**** cleanup pre-install ****"
cd /
rm -rf /tmp/ogg
[[ $? -gt 0 ]] && exit 1
rm -rf /tmp/vorbis
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/theora/install-cmd.sh
cd /tmp/ogg && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/vorbis && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/theora && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
