FROM ubuntu:bionic as buildbase

# Common env
ENV \
 DEBIAN_FRONTEND="noninteractive" \
 MAKEFLAGS="-j4"

#  ____        _ _     _       _                
# | __ ) _   _(_) | __| |   __| | ___ _ __  ___ 
# |  _ \| | | | | |/ _` |  / _` |/ _ \ '_ \/ __|
# | |_) | |_| | | | (_| | | (_| |  __/ |_) \__ \
# |____/ \__,_|_|_|\__,_|  \__,_|\___| .__/|___/
#                                    |_|        
# 
RUN \
    echo "**** install build packages ****" \
        && apt-get update \ 
        && apt-get install -y \
            autoconf \
            automake \
            bzip2 \
            ca-certificates \
            cmake \
            curl \
            diffutils \
            g++ \
            gcc \
            git \
            gperf \
            libexpat1-dev \
            libxext-dev \
            libgcc-7-dev \
            libgomp1 \
            libpciaccess-dev \
            libssl-dev \
            libtool \
            libv4l-dev \
            libx11-dev \
            libxml2-dev \
            make \
            nasm \
            perl \
            pkg-config \
            python \
            x11proto-xext-dev \
            xserver-xorg-dev \
            yasm \
            zlib1g-dev \
    && \
    echo "**** install x86 specific packages ($(uname -m)) ****" \
        && if uname -m | grep -q x86; then \
            apt-get install -y \
                doxygen \
                ninja-build \
                python3 \
                python3-pip\
                python3-setuptools \
                python3-wheel \
            && \
            pip3 install \
                meson; \
        else \
            echo "Arch is not x86. Ignoring"; \
        fi \
    && \
    echo "**** install aarch64 specific packages ($(uname -m)) ****" \
        && if uname -m | grep -q aarch64; then \
            apt-get install -y \
                libfontconfig1-dev; \
        else \
            echo "Arch is not aarch64. Ignoring"; \
        fi \
    && \
    echo "**** cleanup ****" \
        && apt-get autoremove \
        && apt-get clean \
        && rm -rf \
            /tmp/* \
            /var/lib/apt/lists/* \
            /var/tmp/*


#  _____         _                    _           _ _ _         
# |___ / _ __ __| |  _ __   __ _ _ __| |_ _   _  | (_) |__  ___ 
#   |_ \| '__/ _` | | '_ \ / _` | '__| __| | | | | | | '_ \/ __|
#  ___) | | | (_| | | |_) | (_| | |  | |_| |_| | | | | |_) \__ \
# |____/|_|  \__,_| | .__/ \__,_|_|   \__|\__, | |_|_|_.__/|___/
#                   |_|                   |___/                 
#
# LIBAOM
FROM scratch as LIBAOM
COPY --from=buildbase / /
COPY /scripts/LIBAOM /scripts/LIBAOM
ARG LIBAOM
RUN \
    for script in /scripts/LIBAOM/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBFDKAAC
# https://github.com/mstorsjo/fdk-aac/releases
FROM scratch as LIBFDKAAC
COPY --from=buildbase / /
COPY /scripts/LIBFDKAAC /scripts/LIBFDKAAC
ARG LIBFDKAAC
RUN \
    for script in /scripts/LIBFDKAAC/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# NVCODEC
FROM scratch as NVCODEC
COPY --from=buildbase / /
COPY /scripts/NVCODEC /scripts/NVCODEC
ARG NVCODEC
RUN \
    for script in /scripts/NVCODEC/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBFREETYPE
FROM scratch as LIBFREETYPE
COPY --from=buildbase / /
COPY /scripts/LIBFREETYPE /scripts/LIBFREETYPE
ARG LIBFREETYPE
RUN \
    for script in /scripts/LIBFREETYPE/*.sh; do \
        chmod +x "${script}" \
        && echo "RUNNING: ${script}" \
        && sleep 3 \
        && bash -c "${script}" ; \
    done

# FONTCONFIG
FROM scratch as FONTCONFIG
COPY --from=buildbase / /
COPY --from=LIBFREETYPE /tmp/freetype /tmp/freetype
COPY /scripts/FONTCONFIG /scripts/FONTCONFIG
ARG FONTCONFIG
RUN \
    for script in /scripts/FONTCONFIG/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBFRIBIDI
FROM scratch as LIBFRIBIDI
COPY --from=buildbase / /
COPY /scripts/LIBFRIBIDI /scripts/LIBFRIBIDI
ARG LIBFRIBIDI
RUN \
    for script in /scripts/LIBFRIBIDI/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# KVAZAAR
FROM scratch as KVAZAAR
COPY --from=buildbase / /
COPY /scripts/KVAZAAR /scripts/KVAZAAR
ARG KVAZAAR
RUN \
    for script in /scripts/KVAZAAR/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LAME
FROM scratch as LAME
COPY --from=buildbase / /
COPY /scripts/LAME /scripts/LAME
ARG LAME
RUN \
    for script in /scripts/LAME/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBASS
FROM scratch as LIBASS
COPY --from=buildbase / /
COPY --from=LIBFREETYPE /tmp/freetype /tmp/freetype
COPY --from=FONTCONFIG /tmp/fontconfig /tmp/fontconfig
COPY --from=LIBFRIBIDI /tmp/fribidi /tmp/fribidi
COPY /scripts/LIBASS /scripts/LIBASS
ARG LIBASS
RUN \
    for script in /scripts/LIBASS/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBDRM
# https://dri.freedesktop.org/libdrm/
FROM scratch as LIBDRM
COPY --from=buildbase / /
COPY /scripts/LIBDRM /scripts/LIBDRM
ARG LIBDRM
RUN \
    for script in /scripts/LIBDRM/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBVA
FROM scratch as LIBVA
COPY --from=buildbase / /
COPY /scripts/LIBVA /scripts/LIBVA
ARG LIBVA
RUN \
    for script in /scripts/LIBVA/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBVDPAU
# https://gitlab.freedesktop.org/vdpau/libvdpau/-/tree/1.4
FROM scratch as LIBVDPAU
COPY --from=buildbase / /
COPY /scripts/LIBVDPAU /scripts/LIBVDPAU
ARG LIBVDPAU
RUN \
    for script in /scripts/LIBVDPAU/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# NASM
# https://www.nasm.us/pub/nasm/releasebuilds/
FROM scratch as NASM
COPY --from=buildbase / /
COPY /scripts/NASM /scripts/NASM
ARG NASM
RUN \
    for script in /scripts/NASM/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# LIBVMAF
# https://github.com/Netflix/vmaf/releases
FROM scratch as LIBVMAF
COPY --from=buildbase / /
COPY --from=NASM /tmp/nasm /tmp/nasm
COPY /scripts/LIBVMAF /scripts/LIBVMAF
ARG LIBVMAF
RUN \
    for script in /scripts/LIBVMAF/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# https://ftp.osuosl.org/pub/xiph/releases/ogg/?C=M;O=D
FROM scratch as OGG
COPY --from=buildbase / /
ARG OGG
RUN \
    echo "**** grabbing ogg ****" \
        && mkdir -p /tmp/ogg \
        && curl -Lf \
            http://downloads.xiph.org/releases/ogg/libogg-${OGG}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/ogg
RUN \
    echo "**** compiling ogg ****" \
        && cd /tmp/ogg \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# https://sourceforge.net/projects/opencore-amr/files/opencore-amr/
FROM scratch as OPENCOREAMR
COPY --from=buildbase / /
ARG OPENCOREAMR
RUN \
    echo "**** grabbing opencore-amr ****" \
        && mkdir -p /tmp/opencore-amr \
        && curl -Lf \
            http://downloads.sourceforge.net/project/opencore-amr/opencore-amr/opencore-amr-${OPENCOREAMR}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/opencore-amr
RUN \
    echo "**** compiling opencore-amr ****" \
        && cd /tmp/opencore-amr \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# https://github.com/uclouvain/openjpeg/releases
FROM scratch as OPENJPEG
COPY --from=buildbase / /
ARG OPENJPEG
RUN \
    echo "**** grabbing openjpeg ****" \
        && mkdir -p /tmp/openjpeg \
        && curl -Lf \
            https://github.com/uclouvain/openjpeg/archive/v${OPENJPEG}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/openjpeg
RUN \
    echo "**** compiling openjpeg ****" \
        && cd /tmp/openjpeg \
        && rm -Rf \
            thirdparty/libpng/* \
        && curl -Lf \
            https://download.sourceforge.net/libpng/libpng-1.6.37.tar.gz | \
            tar -zx --strip-components=1 -C thirdparty/libpng/ \
        && cmake \
            -DBUILD_STATIC_LIBS=0 \
            -DBUILD_THIRDPARTY:BOOL=ON . \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# https://archive.mozilla.org/pub/opus/
FROM scratch as OPUS
COPY --from=buildbase / /
ARG OPUS
RUN \
    echo "**** grabbing opus ****" \
        && mkdir -p /tmp/opus \
        && curl -Lf \
            https://archive.mozilla.org/pub/opus/opus-${OPUS}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/opus
RUN \
    echo "**** compiling opus ****" \
        && cd /tmp/opus \
        && autoreconf -fiv \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# VORBIS
# https://ftp.osuosl.org/pub/xiph/releases/vorbis/
FROM scratch as VORBIS
COPY --from=buildbase / /
COPY --from=OGG /tmp/ogg /tmp/ogg
COPY /scripts/VORBIS /scripts/VORBIS
ARG VORBIS
RUN \
    for script in /scripts/VORBIS/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# THEORA
# https://ftp.osuosl.org/pub/xiph/releases/theora/
FROM scratch as THEORA
COPY --from=buildbase / /
COPY --from=OGG /tmp/ogg /tmp/ogg
COPY --from=VORBIS /tmp/vorbis /tmp/vorbis
COPY /scripts/THEORA /scripts/THEORA
ARG THEORA
RUN \
    for script in /scripts/THEORA/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# https://github.com/georgmartius/vid.stab/releases
FROM scratch as LIBVIDSTAB
COPY --from=buildbase / /
ARG LIBVIDSTAB
RUN \
    echo "**** grabbing vid.stab ****" \
        && mkdir -p /tmp/vid.stab \
        && curl -Lf \
            https://github.com/georgmartius/vid.stab/archive/v${LIBVIDSTAB}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/vid.stab
RUN \
    echo "**** compiling vid.stab ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/vid.stab \
            && cmake \
                -DBUILD_STATIC_LIBS=0 . \
            && make -j$(nproc) \
            && echo 'make install' > ./install-cmd.sh; \ 
        else \
            cd /tmp/vid.stab \
            && echo "" > \
                CMakeModules/FindSSE.cmake \
            && cmake . \
            && make -j$(nproc) \
            && echo 'make install' > ./install-cmd.sh; \
        fi

# https://github.com/webmproject/libvpx/releases
FROM scratch as VPX
COPY --from=buildbase / /
ARG VPX
RUN \
    echo "**** grabbing vpx ****" \
        && mkdir -p /tmp/vpx \
        && curl -Lf \
            https://github.com/webmproject/libvpx/archive/v${VPX}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/vpx
RUN \
    echo "**** compiling vpx ****" \
        && if uname -m | grep -q armv7l; then \
            echo "  - building for armv7l" \
            && export ADDITIONAL_LDFLAGS='-mfloat-abi=hard' \
            && export ADDITIONAL_CONFIG_ARGS='--enable-vp9-highbitdepth --extra-cflags="-mfloat-abi=hard" --extra-cxxflags="-mfloat-abi=hard"'; \
        fi \
        && cd /tmp/vpx \
        && LDFLAGS=${ADDITIONAL_LDFLAGS} ./configure \
            --disable-debug \
            --disable-docs \
            --disable-examples \
            --disable-install-bins \
            --disable-static \
            --disable-unit-tests \
            --enable-pic \
            --enable-shared \
            --enable-vp8 \
            --enable-vp9 \
            --enable-vp9-highbitdepth ${ADDITIONAL_CONFIG_ARGS} \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

FROM scratch as X264
COPY --from=buildbase / /
ARG X264
RUN \
    echo "**** grabbing x264 ****" \
        && mkdir -p /tmp/x264 \
        && curl -Lf \
            https://code.videolan.org/videolan/x264/-/archive/master/x264-${X264}.tar.bz2 | \
            tar -jx --strip-components=1 -C /tmp/x264
RUN \
    echo "**** compiling x264 ****" \
        && cd /tmp/x264 \
        && ./configure \
            --disable-cli \
            --disable-static \
            --enable-pic \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# X265
FROM scratch as X265
COPY --from=buildbase / /
COPY /scripts/X265 /scripts/X265
ARG X265
RUN \
    for script in /scripts/X265/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

FROM scratch as XVID
COPY --from=buildbase / /
ARG XVID
RUN \
    echo "**** grabbing xvid ****" \
        && mkdir -p /tmp/xvid \
        && curl -Lf \
            https://downloads.xvid.com/downloads/xvidcore-${XVID}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/xvid
RUN \
    echo "**** compiling xvid ****" \
        && cd /tmp/xvid/build/generic \
        && ./configure \ 
        && make -j$(nproc) \
        && echo 'cd /tmp/xvid/build/generic && make install' > /tmp/xvid/install-cmd.sh

# https://code.videolan.org/videolan/dav1d
FROM scratch as LIBDAV1D
COPY --from=buildbase / /
COPY --from=NASM /tmp/nasm /tmp/nasm
COPY /scripts/LIBDAV1D /scripts/LIBDAV1D
ARG LIBDAV1D
RUN \
    for script in /scripts/LIBDAV1D/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" ; \
    done

# https://github.com/sekrit-twc/zimg/
FROM scratch as ZIMG
COPY --from=buildbase / /
ARG ZIMG
RUN \
    echo "**** grabbing zimg ****" \
        && mkdir -p /tmp/zimg \
        && curl -Lf \
            https://github.com/sekrit-twc/zimg/archive/refs/tags/release-${ZIMG}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/zimg
RUN \
    echo "**** compiling zimg ****" \
        && cd /tmp/zimg \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# https://sourceforge.net/projects/soxr
FROM scratch as SOXR
COPY --from=buildbase / /
ARG SOXR
RUN \
    echo "**** grabbing soxr ****" \
        && mkdir -p /tmp/soxr \
        && curl -Lf \
            https://downloads.sourceforge.net/project/soxr/soxr-${SOXR}-Source.tar.xz -o /tmp/soxr-${SOXR}-Source.tar.xz \
        && tar xf /tmp/soxr-${SOXR}-Source.tar.xz --strip-components=1 -C /tmp/soxr \ 
        && rm /tmp/soxr-${SOXR}-Source.tar.xz
RUN \
    echo "**** compiling soxr ****" \
        && cd /tmp/soxr \
        && mkdir -p ./build \
        && cd ./build \
        && cmake -G "Unix Makefiles" -DBUILD_STATIC_LIBS=0 -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off -DCMAKE_BUILD_TYPE=Release .. \
        && make -j$(nproc) \
        && echo 'cd /tmp/soxr/build && make install' > /tmp/soxr/install-cmd.sh

# https://github.com/xiph/speex/
FROM scratch as SPEEX
COPY --from=buildbase / /
ARG SPEEX
RUN \
    echo "**** grabbing speex ****" \
        && mkdir -p /tmp/speex \
        && curl -Lf \
            https://github.com/xiph/speex/archive/refs/tags/Speex-${SPEEX}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/speex
RUN \
    echo "**** compiling speex ****" \
        && cd /tmp/speex \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/
FROM scratch as LIBVOAMRWBENC
COPY --from=buildbase / /
ARG LIBVOAMRWBENC
RUN \
    echo "**** grabbing vo-amrwbenc ****" \
        && mkdir -p /tmp/vo-amrwbenc \
        && curl -Lf \
            http://downloads.sourceforge.net/opencore-amr/vo-amrwbenc/vo-amrwbenc-${LIBVOAMRWBENC}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/vo-amrwbenc
RUN \
    echo "**** compiling vo-amrwbenc ****" \
        && cd /tmp/vo-amrwbenc \
        && ./configure \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh

# https://chromium.googlesource.com/webm/libwebp.git
FROM scratch as LIBWEBP
COPY --from=buildbase / /
ARG LIBWEBP
RUN \
    echo "**** grabbing libwebp ****" \
        && mkdir -p /tmp/libwebp \
        && git clone \
            --branch ${LIBWEBP} \
            --depth 1 https://chromium.googlesource.com/webm/libwebp.git \
            /tmp/libwebp
RUN \
    echo "**** compiling libwebp ****" \
        && cd /tmp/libwebp \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j$(nproc) \
        && echo 'make install' > ./install-cmd.sh


#  _____ _____ __  __ ____  _____ ____ 
# |  ___|  ___|  \/  |  _ \| ____/ ___|
# | |_  | |_  | |\/| | |_) |  _|| |  _ 
# |  _| |  _| | |  | |  __/| |__| |_| |
# |_|   |_|   |_|  |_|_|   |_____\____|
#                                      
#
FROM scratch as FFMPEG
COPY --from=buildbase / /
# Download FFmpeg
ARG FFMPEG_VERSION
RUN \
    echo "**** grabbing ffmpeg ****" \
        && mkdir -p /ffmpeg \
        && echo "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2" \
        && curl -Lf \
            https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
            tar -jx --strip-components=1 -C /ffmpeg
# Add all 3rd party lib build directories to this image
COPY --from=FONTCONFIG     /tmp   /tmp
COPY --from=KVAZAAR        /tmp   /tmp
COPY --from=LAME           /tmp   /tmp
COPY --from=LIBAOM         /tmp   /tmp
COPY --from=LIBASS         /tmp   /tmp
COPY --from=LIBDAV1D       /tmp   /tmp
COPY --from=LIBDRM         /tmp   /tmp
COPY --from=LIBFDKAAC      /tmp   /tmp
COPY --from=LIBFREETYPE    /tmp   /tmp
COPY --from=LIBFRIBIDI     /tmp   /tmp
COPY --from=LIBVA          /tmp   /tmp
COPY --from=LIBVDPAU       /tmp   /tmp
COPY --from=LIBVIDSTAB     /tmp   /tmp
COPY --from=LIBVMAF        /tmp   /tmp
COPY --from=LIBVOAMRWBENC  /tmp   /tmp
COPY --from=LIBWEBP        /tmp   /tmp
COPY --from=NASM           /tmp   /tmp
COPY --from=NVCODEC        /tmp   /tmp
COPY --from=OGG            /tmp   /tmp
COPY --from=OPENCOREAMR    /tmp   /tmp
COPY --from=OPENJPEG       /tmp   /tmp
COPY --from=OPUS           /tmp   /tmp
COPY --from=SOXR           /tmp   /tmp
COPY --from=SPEEX          /tmp   /tmp
COPY --from=THEORA         /tmp   /tmp
COPY --from=VORBIS         /tmp   /tmp
COPY --from=VPX            /tmp   /tmp
COPY --from=X264           /tmp   /tmp
COPY --from=X265           /tmp   /tmp
COPY --from=XVID           /tmp   /tmp
COPY --from=ZIMG           /tmp   /tmp
# Build FFmpeg
COPY /scripts/FFMPEG /scripts/FFMPEG
RUN \
    for script in /scripts/FFMPEG/*.sh; do \
        chmod +x "${script}" \
        && bash -c "${script}" \
        && if [ $? -gt 0 ]; then \
            exit 1; \
        fi \
    done
# Compile FFmpeg
RUN \
    echo "**** compiling ffmpeg ****" \
        && if uname -m | grep -q x86; then \
            ADDITIONAL_FFMPEG_ARGS='--enable-libdav1d --enable-cuvid --enable-libvmaf --enable-nvdec --enable-nvenc --enable-vaapi --enable-vdpau'; \ 
        fi \
        && cd /ffmpeg \
        && ./configure \
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
            --enable-openssl ${ADDITIONAL_FFMPEG_ARGS} \
        && make -j$(nproc)
# Install FFmpeg and all libs to /buildout directroy
RUN \
    echo "**** arrange files ****" \
        && ldconfig \
        && mkdir -p /buildout/usr/local/bin \
        && cp \
            /ffmpeg/ffmpeg \
            /buildout/usr/local/bin \
        && cp \
            /ffmpeg/ffprobe \
            /buildout/usr/local/bin \
        && mkdir -p /buildout/usr/lib \
        && ldd /ffmpeg/ffmpeg \
            | awk '/local/ {print $3}' \
            | xargs -i cp -L {} /buildout/usr/lib/ \
        && if uname -m | grep -q x86; then \
            if ls /usr/local/lib/libdrm_* 1> /dev/null 2>&1; then \
                cp -a \
                    /usr/local/lib/libdrm_* \
                    /buildout/usr/lib/; \
            fi \
            && \
            if ls /usr/local/lib/x86_64-linux-gnu/libdrm_* 1> /dev/null 2>&1; then \
                cp -a \
                    /usr/local/lib/x86_64-linux-gnu \
                    /buildout/usr/lib/; \
            fi \
        fi


#  _____                       _   
# | ____|_  ___ __   ___  _ __| |_ 
# |  _| \ \/ / '_ \ / _ \| '__| __|
# | |___ >  <| |_) | (_) | |  | |_ 
# |_____/_/\_\ .__/ \___/|_|   \__|
#            |_|                   
# 
# Export the storage layer consumed downstream
FROM scratch

# Set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Josh.5"

# Add files from buildstage
COPY --from=FFMPEG /buildout/ /

COPY /versions.cfg /versions.cfg
