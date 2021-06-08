###
# File: 30_build_ffmpeg.sh
# Project: FFMPEG
# File Created: Tuesday, 8th June 2021 11:10:45 pm
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Wednesday, 9th June 2021 1:38:20 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

# TODO: Look into adding...
## --enable-frei0r
## --enable-gnutls
## --enable-gmp
## --enable-libgme
## --enable-librubberband
## --enable-libsrt
## --enable-libzvbi

# Temporarily disable this script
exit 0 

echo "**** compiling ffmpeg ****"
if uname -m | grep -q x86; then
    ADDITIONAL_FFMPEG_ARGS='--enable-libdav1d --enable-cuvid --enable-libvmaf --enable-nvdec --enable-nvenc --enable-vaapi --enable-vdpau'
else
    ADDITIONAL_FFMPEG_ARGS=''
fi

cd /ffmpeg
./configure \
    --enable-gpl \
    --enable-nonfree \
    --enable-version3 \
    --disable-debug \
    --disable-doc \
    --disable-ffplay \
    --disable-indev=sndio \
    --disable-outdev=sndio \
    --cc=gcc \
    --enable-avresample \
    --enable-ffprobe \
    --enable-fontconfig \
    --enable-gray \
    --enable-libaom \
    --enable-libass \
    --enable-libfdk_aac \
    --enable-libfreetype \
    --enable-libfribidi \
    --enable-libkvazaar \
    --enable-libmp3lame \
    --enable-libopencore-amrnb \
    --enable-libopencore-amrwb \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-libsoxr \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libv4l2 \
    --enable-libvidstab \
    --enable-libvo-amrwbenc \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxml2 \
    --enable-libxvid \
    --enable-libzimg \
    --enable-openssl ${ADDITIONAL_FFMPEG_ARGS}

make -j$(nproc)
[[ $? -gt 0 ]] && exit 1
