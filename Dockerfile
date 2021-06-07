FROM lsiobase/ubuntu:bionic as buildstage


# Common env
ENV \
 DEBIAN_FRONTEND="noninteractive" \
 MAKEFLAGS="-j4"

# Build deps
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
        doxygen \
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
                ninja-build \
                python3 \
                python3-pip\
                python3-setuptools \
                python3-wheel \
            && \
            pip3 install \
                meson; \
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

# Compile 3rd party libs
ARG LIBAOM
RUN \
    echo "**** grabbing aom ****" \
        && mkdir -p /tmp/aom \
        && git clone \
            --branch ${LIBAOM} \
            --depth 1 https://aomedia.googlesource.com/aom \
            /tmp/aom
RUN \
    echo "**** compiling aom ****" \
        && cd /tmp/aom \
        && rm -rf \
            CMakeCache.txt \
            CMakeFiles \
        && mkdir -p \
            aom_build \
        && cd aom_build \
        && cmake \
            -DBUILD_STATIC_LIBS=0 .. \
        && make \
        && make install

# https://github.com/mstorsjo/fdk-aac/releases
ARG LIBFDKAAC
RUN \
    echo "**** grabbing fdk-aac ****" \
        && mkdir -p /tmp/fdk-aac \
        && curl -Lf \
            https://github.com/mstorsjo/fdk-aac/archive/v${LIBFDKAAC}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/fdk-aac
RUN \
    echo "**** compiling fdk-aac ****" \
        && cd /tmp/fdk-aac \
        && autoreconf -fiv \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

ARG NVCODEC
RUN \
    echo "**** grabbing ffnvcodec ****" \
        && if uname -m | grep -q x86; then \
            mkdir -p /tmp/ffnvcodec \
            && git clone \
                --branch ${NVCODEC} \
                --depth 1 https://git.videolan.org/git/ffmpeg/nv-codec-headers.git \
                /tmp/ffnvcodec; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi
RUN \
    echo "**** compiling ffnvcodec ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/ffnvcodec \
            && make install; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

ARG LIBFREETYPE
RUN \
    echo "**** grabbing freetype ****" \
        && mkdir -p /tmp/freetype \
        && curl -Lf \
            https://download.savannah.gnu.org/releases/freetype/freetype-${LIBFREETYPE}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/freetype
RUN \
    echo "**** compiling freetype ****" \
        && cd /tmp/freetype \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

ARG FONTCONFIG
RUN \
    echo "**** grabbing fontconfig ****" \
        && if uname -m | grep -q x86; then \
            mkdir -p /tmp/fontconfig \
            && curl -Lf \
                https://www.freedesktop.org/software/fontconfig/release/fontconfig-${FONTCONFIG}.tar.gz | \
                tar -zx --strip-components=1 -C /tmp/fontconfig; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi
RUN \
    echo "**** compiling fontconfig ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/fontconfig \
            && ./configure \
                --disable-static \
                --enable-shared \
            && make \
            && make install; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

ARG LIBFRIBIDI
RUN \
    echo "**** grabbing fribidi ****" \
        && mkdir -p /tmp/fribidi \
        && curl -Lf \
            https://github.com/fribidi/fribidi/archive/v${LIBFRIBIDI}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/fribidi
RUN \
    echo "**** compiling fribidi ****" \
        && cd /tmp/fribidi \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make -j 1 \
        && make install

ARG KVAZAAR
RUN \
    echo "**** grabbing kvazaar ****" \
        && mkdir -p /tmp/kvazaar \
        && curl -Lf \
            https://github.com/ultravideo/kvazaar/archive/v${KVAZAAR}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/kvazaar
RUN \
    echo "**** compiling kvazaar ****" \
        && cd /tmp/kvazaar \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

ARG LAME
RUN \
    echo "**** grabbing lame ****" \
        && mkdir -p /tmp/lame \
        && curl -Lf \
            http://downloads.sourceforge.net/project/lame/lame/${LAME}/lame-${LAME}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/lame
RUN \
    echo "**** compiling lame ****" \
        && cd /tmp/lame \
        && cp \
            /usr/share/automake-1.15/config.guess \
            config.guess \
        && cp \
            /usr/share/automake-1.15/config.sub \
            config.sub \
        && ./configure \
            --disable-frontend \
            --disable-static \
            --enable-nasm \
            --enable-shared \
        && make \
        && make install

ARG LIBASS
RUN \
    echo "**** grabbing libass ****" \
        && mkdir -p /tmp/libass \
        && curl -Lf \
            https://github.com/libass/libass/archive/${LIBASS}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/libass
RUN \
    echo "**** compiling libass ****" \
        && cd /tmp/libass \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

# https://dri.freedesktop.org/libdrm/
ARG LIBDRM
RUN \
    echo "**** grabbing libdrm ****" \
        && if uname -m | grep -q x86; then \
            mkdir -p /tmp/libdrm \
            && curl -Lf \
                https://dri.freedesktop.org/libdrm/libdrm-${LIBDRM}.tar.xz -o /tmp/libdrm-${LIBDRM}.tar.xz \
            && tar xf /tmp/libdrm-${LIBDRM}.tar.xz --strip-components=1 -C /tmp/libdrm; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi
RUN \
    echo "**** compiling libdrm ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/libdrm \
            && meson builddir/ \
            && ninja -vC builddir/ install; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

ARG LIBVA
RUN \
    echo "**** grabbing libva ****" \
        && if uname -m | grep -q x86; then \
            mkdir -p /tmp/libva \
            && curl -Lf \
                https://github.com/intel/libva/archive/${LIBVA}.tar.gz | \
                tar -zx --strip-components=1 -C /tmp/libva; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi
RUN \
    echo "**** compiling libva ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/libva \
            && ./autogen.sh \
            && ./configure \
                --disable-static \
                --enable-shared \
            && make \
            && make install; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

# https://gitlab.freedesktop.org/vdpau/libvdpau/-/tree/1.4
ARG LIBVDPAU
RUN \
    echo "**** grabbing libvdpau ****" \
        && if uname -m | grep -q x86; then \
            mkdir -p /tmp/libvdpau \
            && git clone \
                --branch ${LIBVDPAU} \
                --depth 1 https://gitlab.freedesktop.org/vdpau/libvdpau.git \
                /tmp/libvdpau; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi
RUN \
    echo "**** compiling libvdpau ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/libvdpau \
            && ./autogen.sh \
            && ./configure \
                --disable-static \
                --enable-shared \
            && make \
            && make install; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

# https://github.com/Netflix/vmaf/releases
ARG LIBVMAF
RUN \
    echo "**** grabbing vmaf ****" \
        && if uname -m | grep -q x86; then \
            mkdir -p /tmp/vmaf \
            && git clone \
                --branch ${LIBVMAF} \
                https://github.com/Netflix/vmaf.git \
                /tmp/vmaf; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi
RUN \
    echo "**** compiling libvmaf ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/vmaf/libvmaf \
            && meson build --buildtype release \
            && ninja -vC build \
            && ninja -vC build install; \ 
        else \
            echo "Arch does not support x86 runtime packages. Ignoring"; \
        fi

# https://ftp.osuosl.org/pub/xiph/releases/ogg/?C=M;O=D
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
        && make \
        && make install

# https://sourceforge.net/projects/opencore-amr/files/opencore-amr/
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
        && make \
        && make install

# https://github.com/uclouvain/openjpeg/releases
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
        && make \
        && make install

# https://archive.mozilla.org/pub/opus/
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
        && make \
        && make install

# https://ftp.osuosl.org/pub/xiph/releases/theora/
ARG THEORA
RUN \
    echo "**** grabbing theora ****" \
        && mkdir -p /tmp/theora \
        && curl -Lf \
            http://downloads.xiph.org/releases/theora/libtheora-${THEORA}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/theora
RUN \
    echo "**** compiling theora ****" \
        && cd /tmp/theora \
        && cp \
            /usr/share/automake-1.15/config.guess \
            config.guess \
        && cp \
            /usr/share/automake-1.15/config.sub \
            config.sub \
        && curl -fL \
            'https://gitlab.xiph.org/xiph/theora/-/commit/7288b539c52e99168488dc3a343845c9365617c8.diff' \
            > png.patch \
        && patch ./examples/png2theora.c < png.patch \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

# https://github.com/georgmartius/vid.stab/releases
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
            && make \
            && make install; \ 
        else \
            cd /tmp/vid.stab \
            && echo "" > \
                CMakeModules/FindSSE.cmake \
            && cmake . \
            && make \
            && make install; \
        fi

# https://ftp.osuosl.org/pub/xiph/releases/vorbis/
ARG VORBIS
RUN \
    echo "**** grabbing vorbis ****" \
        && mkdir -p /tmp/vorbis \
        && curl -Lf \
            http://downloads.xiph.org/releases/vorbis/libvorbis-${VORBIS}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/vorbis
RUN \
    echo "**** compiling vorbis ****" \
        && cd /tmp/vorbis \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

# https://github.com/webmproject/libvpx/releases
ARG VPX
RUN \
    echo "**** grabbing vpx ****" \
        && mkdir -p /tmp/vpx \
        && curl -Lf \
            https://github.com/webmproject/libvpx/archive/v${VPX}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/vpx
RUN \
    echo "**** compiling vpx ****" \
        && cd /tmp/vpx \
        && ./configure \
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
            --enable-vp9-highbitdepth \
        && make \
        && make install

ARG x264
RUN \
    echo "**** grabbing x264 ****" \
        && mkdir -p /tmp/x264 \
        && curl -Lf \
            https://code.videolan.org/videolan/x264/-/archive/master/x264-${x264}.tar.bz2 | \
            tar -jx --strip-components=1 -C /tmp/x264
RUN \
    echo "**** compiling x264 ****" \
        && cd /tmp/x264 \
        && ./configure \
            --disable-cli \
            --disable-static \
            --enable-pic \
            --enable-shared \
        && make \
        && make install

ARG X265
RUN \
    echo "**** grabbing x265 ****" \
        && mkdir -p /tmp/x265 \
        && curl -Lf \
            http://anduin.linuxfromscratch.org/BLFS/x265/x265_${X265}.tar.gz | \
            tar -zx --strip-components=1 -C /tmp/x265
RUN \
    echo "**** compiling x265 ****" \
        && if uname -m | grep -q x86; then \
            cd /tmp/x265/build/linux \
            && ./multilib.sh \
            && make -C 8bit install; \ 
        else \
            cd /tmp/x265/build/linux \
            && export CXXFLAGS="-fPIC" \
            && ./multilib.sh \
            && make -C 8bit install; \
        fi

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
        && make \
        && make install

# https://www.nasm.us/pub/nasm/releasebuilds/
ARG NASM
RUN \
    echo "**** grabbing nasm ****" \
        && mkdir -p /tmp/nasm \
        && curl -Lf \
            https://www.nasm.us/pub/nasm/releasebuilds/${NASM}/nasm-${NASM}.tar.bz2 | \
            tar -jx --strip-components=1 -C /tmp/nasm
RUN \
    echo "**** compiling nasm ****" \
        && cd /tmp/nasm \
        && ./autogen.sh \
        && ./configure \
            --disable-static \
            --enable-shared \
        && make \
        && make install

# https://code.videolan.org/videolan/dav1d
ARG LIBDAV1D
RUN \
    echo "**** grabbing dav1d ****" \
        && mkdir -p /tmp/dav1d \
        && git clone \
            --branch ${LIBDAV1D} \
            --depth 1 https://code.videolan.org/videolan/dav1d.git \
            /tmp/dav1d
RUN \
    echo "**** compiling dav1d ****" \
        && cd /tmp/dav1d \
        && mkdir -p build \
        && cd build \
        && meson --bindir="/usr/local/bin" .. \
        && ninja \
        && ninja install

# https://github.com/sekrit-twc/zimg/
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
        && make \
        && make install

# https://sourceforge.net/projects/soxr
ARG SOXR
RUN \
    echo "**** grabbing soxr ****" \
        && mkdir -p /tmp/soxr \
        && curl -Lf \
            https://downloads.sourceforge.net/project/soxr/soxr-${SOXR}-Source.tar.xz -o /tmp/soxr-${SOXR}-Source.tar.xz \
        && rm -rfv /tmp/soxr/* \
        && tar xf /tmp/soxr-${SOXR}-Source.tar.xz --strip-components=1 -C /tmp/soxr
RUN \
    echo "**** compiling soxr ****" \
        && cd /tmp/soxr \
        && mkdir -p ./build \
        && cd ./build \
        && cmake -G "Unix Makefiles" -DWITH_OPENMP:bool=off -DBUILD_TESTS:bool=off -DCMAKE_BUILD_TYPE=Release .. \
        && make \
        && make install

# https://github.com/xiph/speex/
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
        && make \
        && make install

# https://sourceforge.net/projects/opencore-amr/files/vo-amrwbenc/
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
        && make \
        && make install

# https://chromium.googlesource.com/webm/libwebp.git
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
        && make \
        && make install

# Main ffmpeg build
ARG FFMPEG_VERSION
RUN \
    echo "**** grabbing ffmpeg ****" \
        && mkdir -p /tmp/ffmpeg \
        && echo "https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2" \
        && curl -Lf \
            https://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2 | \
            tar -jx --strip-components=1 -C /tmp/ffmpeg
RUN \
    echo "**** compiling ffmpeg ****" \
        && if uname -m | grep -q x86; then \
            ADDITIONAL_FFMPEG_ARGS='--enable-cuvid --enable-libvmaf --enable-nvdec --enable-nvenc --enable-vaapi --enable-vdpau'; \ 
        fi \
        && cd /tmp/ffmpeg \
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
            --enable-libdav1d \
            --enable-libfdk_aac \
            --enable-libfreetype \
            --enable-libfribidi \
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
            --enable-libvmaf \
            --enable-libvo-amrwbenc \
            --enable-libvorbis \
            --enable-libvpx \
            --enable-libwebp \
            --enable-libx264 \
            --enable-libx265 \
            --enable-libxml2 \
            --enable-libxvid \
            --enable-libzimg \
            --enable-openssl \
            ${ADDITIONAL_FFMPEG_ARGS} \
        && make
# TODO: Re-enable...
## --enable-libkvazaar

# TODO: Look into adding...
## --enable-frei0r
## --enable-gnutls
## --enable-gmp
## --enable-libgme
## --enable-librubberband
## --enable-libsrt
## --enable-libzvbi

RUN \
    echo "**** arrange files ****" \
        && ldconfig \
        && mkdir -p /buildout/usr/local/bin \
        && cp \
            /tmp/ffmpeg/ffmpeg \
            /buildout/usr/local/bin \
        && cp \
            /tmp/ffmpeg/ffprobe \
            /buildout/usr/local/bin \
        && mkdir -p /buildout/usr/lib \
        && ldd /tmp/ffmpeg/ffmpeg \
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


# Storage layer consumed downstream
FROM scratch

# Set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="Josh.5"

# Add files from buildstage
COPY --from=buildstage /buildout/ /

COPY /versions.cfg /versions.cfg
