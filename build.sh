#!/bin/bash
###
# File: build.sh
# Project: docker-ffmpeg
# File Created: Saturday, 5th June 2021 1:08:20 am
# Author: Josh.5 (jsunnex@gmail.com)
# -----
# Last Modified: Monday, 7th June 2021 6:57:01 pm
# Modified By: Josh.5 (jsunnex@gmail.com)
###

source $(dirname ${BASH_SOURCE[0]})/versions.cfg

BUILD_DATE=$(date '+%Y-%m-%dT%H:%M:%S%:z')

docker buildx build \
    --build-arg VERSION=bin \
    --build-arg FFMPEG_VERSION=${FFMPEG_VERSION} \
    --build-arg BUILD_DATE=${BUILD_DATE} \
    --build-arg FONTCONFIG=${FONTCONFIG} \
    --build-arg FREETYPE=${FREETYPE} \
    --build-arg KVAZAAR=${KVAZAAR} \
    --build-arg LAME=${LAME} \
    --build-arg LIBAOM=${LIBAOM} \
    --build-arg LIBASS=${LIBASS} \
    --build-arg LIBDAV1D=${LIBDAV1D} \
    --build-arg LIBDRM=${LIBDRM} \
    --build-arg LIBFDKAAC=${LIBFDKAAC} \
    --build-arg LIBFREETYPE=${LIBFREETYPE} \
    --build-arg LIBFRIBIDI=${LIBFRIBIDI} \
    --build-arg LIBVA=${LIBVA} \
    --build-arg LIBVDPAU=${LIBVDPAU} \
    --build-arg LIBVIDSTAB=${LIBVIDSTAB} \
    --build-arg LIBVMAF=${LIBVMAF} \
    --build-arg LIBVOAMRWBENC=${LIBVOAMRWBENC} \
    --build-arg LIBWEBP=${LIBWEBP} \
    --build-arg NASM=${NASM} \
    --build-arg NVCODEC=${NVCODEC} \
    --build-arg OGG=${OGG} \
    --build-arg OPENCOREAMR=${OPENCOREAMR} \
    --build-arg OPENJPEG=${OPENJPEG} \
    --build-arg OPUS=${OPUS} \
    --build-arg SOXR=${SOXR} \
    --build-arg SPEEX=${SPEEX} \
    --build-arg THEORA=${THEORA} \
    --build-arg VORBIS=${VORBIS} \
    --build-arg VPX=${VPX} \
    --build-arg X264=${X264} \
    --build-arg X265=${X265} \
    --build-arg XVID=${XVID} \
    --build-arg ZIMG=${ZIMG} \
    --tag josh5/ffmpeg:latest \
    --platform linux/amd64 \
    --iidfile /tmp/docker-build-push-D4bGPh/iidfile \
    --cache-from type=local,src=/tmp/.buildx-cache \
    --cache-to type=local,dest=/tmp/.buildx-cache \
    --file Dockerfile .
