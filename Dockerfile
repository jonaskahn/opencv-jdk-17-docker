FROM alpine:3.17

LABEL maintainer="tuyendev@gmail.com"

RUN apk add --no-cache --update alpine-sdk
RUN apk add --no-cache libffi-dev openssl-dev
RUN apk add --no-cache --update build-base
RUN apk add --no-cache zip
RUN apk add --no-cache cmake bash curl nano

RUN wget -O /THIRD-PARTY-LICENSES-20200824.tar.gz https://corretto.aws/downloads/resources/licenses/alpine/THIRD-PARTY-LICENSES-20200824.tar.gz && \
    echo "82f3e50e71b2aee21321b2b33de372feed5befad6ef2196ddec92311bc09becb  /THIRD-PARTY-LICENSES-20200824.tar.gz" | sha256sum -c - && \
    tar x -ovzf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    rm -rf THIRD-PARTY-LICENSES-20200824.tar.gz && \
    wget -O /etc/apk/keys/amazoncorretto.rsa.pub https://apk.corretto.aws/amazoncorretto.rsa.pub && \
    SHA_SUM="6cfdf08be09f32ca298e2d5bd4a359ee2b275765c09b56d514624bf831eafb91" && \
    echo "${SHA_SUM}  /etc/apk/keys/amazoncorretto.rsa.pub" | sha256sum -c - && \
    echo "https://apk.corretto.aws" >> /etc/apk/repositories

RUN apk add --no-cache amazon-corretto-17
RUN apk add --no-cache apache-ant 
    
ENV LANG C.UTF-8

ENV JAVA_HOME=/usr/lib/jvm/default-jvm
ENV PATH=$PATH:/usr/lib/jvm/default-jvm/bin

COPY opencv-4.7.0.zip /tmp
RUN cd /tmp && unzip opencv-4.7.0.zip

RUN mkdir -p /tmp/opencv-4.7.0/build
RUN cd /tmp/opencv-4.7.0/build && \
    cmake   -DCMAKE_INSTALL_PREFIX=/usr/local \
            -DCMAKE_BUILD_TYPE=RELEASE \
            -DBUILD_SHARED_LIBS=OFF \
            -DCMAKE_CXX_STANDARD=11 \
            -DBUILD_JASPER=OFF \
            -DBUILD_JPEG=OFF \
            -DBUILD_OPENEXR=OFF \
            -DBUILD_OPENJPEG=OFF \
            -DBUILD_PERF_TESTS=OFF \
            -DBUILD_PNG=OFF \
            -DBUILD_PROTOBUF=OFF \
            -DBUILD_TBB=OFF \
            -DBUILD_TESTS=OFF \
            -DBUILD_TIFF=OFF \
            -DBUILD_WEBP=OFF \
            -DBUILD_ZLIB=OFF \
            -DBUILD_opencv_hdf=OFF \
            -DBUILD_opencv_java=ON \
            -DBUILD_opencv_text=ON \
            -DOPENCV_ENABLE_NONFREE=ON \
            -DOPENCV_GENERATE_PKGCONFIG=ON \
            -DPROTOBUF_UPDATE_FILES=ON \
            -DWITH_1394=OFF \
            -DWITH_CUDA=OFF \
            -DWITH_EIGEN=ON \
            -DWITH_FFMPEG=ON \
            -DWITH_GPHOTO2=OFF \
            -DWITH_GSTREAMER=OFF \
            -DWITH_JASPER=OFF \
            -DWITH_OPENEXR=ON \
            -DWITH_OPENGL=OFF \
            -DWITH_QT=OFF \
            -DWITH_TBB=ON \
            -DWITH_VTK=ON \
            -DBUILD_opencv_python2=OFF \
            -DBUILD_opencv_python3=OFF \
            -DENABLE_PRECOMPILED_HEADERS=OFF \
            -DWITH_V4L=OFF \
            -DOPENCV_GENERATE_PKGCONFIG=ON ../
RUN cd /tmp/opencv-4.7.0/build && make && make install
RUN pkg-config --modversion opencv4
RUN rm -rf /tmp/*

RUN mkdir /app
WORKDIR /app
