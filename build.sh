#!/bin/bash
###
# File: build.sh
# Project: docker-ffmpeg
# File Created: Saturday, 5th June 2021 1:08:20 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Saturday, 5th June 2021 4:18:24 am
# Modified By: Josh.5 (jsunnex@gmail.com)
###

source $(dirname ${BASH_SOURCE[0]})/versions.cfg

BUILD_DATE=$(date '+%Y-%m-%dT%H:%M:%S%:z')

docker build --pull \
    --build-arg VERSION=bin \
    --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
    --build-arg BUILD_DATE=${BUILD_DATE} \
    --build-arg AOM=${AOM} \
    --build-arg FDKAAC=${FDKAAC} \
    --build-arg FFMPEG_HARD=${FFMPEG_HARD} \
    --build-arg FONTCONFIG=${FONTCONFIG} \
    --build-arg FREETYPE=${FREETYPE} \
    --build-arg FRIBIDI=${FRIBIDI} \
    --build-arg KVAZAAR=${KVAZAAR} \
    --build-arg LAME=${LAME} \
    --build-arg LIBASS=${LIBASS} \
    --build-arg LIBDRM=${LIBDRM} \
    --build-arg LIBVA=${LIBVA} \
    --build-arg LIBVDPAU=${LIBVDPAU} \
    --build-arg LIBVIDSTAB=${LIBVIDSTAB} \
    --build-arg LIBVMAF=${LIBVMAF} \
    --build-arg NVCODEC=${NVCODEC} \
    --build-arg OGG=${OGG} \
    --build-arg OPENCOREAMR=${OPENCOREAMR} \
    --build-arg OPENJPEG=${OPENJPEG} \
    --build-arg OPUS=${OPUS} \
    --build-arg THEORA=${THEORA} \
    --build-arg VORBIS=${VORBIS} \
    --build-arg VPX=${VPX} \
    --build-arg x264=${x264} \
    --build-arg X265=${X265} \
    --build-arg XVID=${XVID} \
    -t josh5/ffmpeg:latest .
