###
# File: 20_build.sh
# Project: LAME
# File Created: Wednesday, 9th June 2021 12:36:46 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 12:40:52 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling lame ****"
cd /tmp/lame

cp /usr/share/automake-1.15/config.guess config.guess
cp /usr/share/automake-1.15/config.sub config.sub

./configure \
    --disable-frontend \
    --disable-static \
    --enable-nasm \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/lame/install-cmd.sh
cd /tmp/lame && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
