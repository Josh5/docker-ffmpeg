###
# File: 20_build.sh
# Project: LIBFDKAAC
# File Created: Tuesday, 8th June 2021 11:29:56 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:21:18 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

echo "**** compiling fdk-aac ****"
cd /tmp/fdk-aac
autoreconf -fiv
./configure \
    --disable-static \
    --enable-shared
make -j$(nproc)
[[ $? -gt 0 ]] && exit 1

# Write install script
cat << 'EOF' > /tmp/fdk-aac/install-cmd.sh
cd /tmp/fdk-aac && make install
if [ $? -gt 0 ]; then exit 1; fi
EOF
