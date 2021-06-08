###
# File: 20_build.sh
# Project: VORBIS
# File Created: Wednesday, 9th June 2021 12:47:28 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:50:13 am
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

echo "**** compiling vorbis ****"
cd /tmp/vorbis
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

echo "**** cleanup pre-install ****"
cd /
rm -rf /tmp/ogg
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/vorbis/install-cmd.sh
cd /tmp/ogg && . ./install-cmd.sh
if [ $? -gt 0 ]; then exit 1; fi

cd /tmp/vorbis && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
