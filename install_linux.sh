#! /bin/bash

# Get the directory containing this script
SCRIPT_DIR=$(dirname "$(readlink -f "$0")")

# Push to parent directory of scripts folder
pushd "${SCRIPT_DIR}" > /dev/null

install_opencv_linux() {
  git clone --depth 1 --branch 4.11.0 https://github.com/opencv/opencv.git

  ARCHS=("x86_64" "aarch64")

  for ARCH in "${ARCHS[@]}"; do
    rm -rf ./build/Linux/opencv/$ARCH
    rm -rf ./install/Linux/opencv/$ARCH

    # Set the toolchain file for cross-compilation
    if [ "$ARCH" = "aarch64" ]; then
      cmake \
        -G Ninja \
        -S opencv \
        -B ./build/Linux/opencv/$ARCH \
        -DBUILD_LIST=core,imgproc,features2d,flann,calib3d,videoio,video,highgui \
        -DCMAKE_BUILD_TYPE=Release \
        -DOPENCV_GENERATE_PKGCONFIG=ON \
        -DOPENCV_GENERATE_CONFIG_FILE=ON \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_opencv_flann=ON \
        -DBUILD_opencv_calib3d=ON \
        -DBUILD_opencv_dnn=OFF \
        -DBUILD_opencv_features2d=ON \
        -DBUILD_opencv_photo=OFF \
        -DBUILD_opencv_objdetect=OFF \
        -DBUILD_opencv_ml=OFF \
        -DBUILD_opencv_video=ON \
        -DBUILD_opencv_videoio=ON \
        -DBUILD_opencv_highgui=ON \
        -DBUILD_opencv_gapi=OFF \
        -DBUILD_PROTOBUFF=OFF \
        -DWITH_ADE=OFF \
        -DWITH_PROTOBUF=OFF \
        -DWITH_CAROTENE=OFF \
        -DWITH_TIFF=OFF \
        -DWITH_PNG=OFF \
        -DWITH_OPENEXR=OFF \
        -DWITH_OPENJPEG=OFF \
        -DWITH_WEBP=OFF \
        -DWITH_JASPER=OFF \
        -DWITH_IMGCODEC_HDR=OFF \
        -DWITH_IMGCODEC_PFM=OFF \
        -DWITH_IMGCODEC_PXM=OFF \
        -DWITH_IMGCODEC_SUNRASTER=OFF \
        -DWITH_GSTREAMER=OFF \
        -DWITH_FFMPEG=ON \
        -DWITH_QUIRC=OFF \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DBUILD_PERF_TESTS=OFF \
        -DBUILD_DOCS=OFF \
        -DCMAKE_TOOLCHAIN_FILE=$(pwd)/linux-arm64.cmake
 
    elif [ "$ARCH" = "x86_64" ]; then
      cmake \
        -G Ninja \
        -S opencv \
        -B ./build/Linux/opencv/$ARCH \
        -DBUILD_LIST=core,imgproc,features2d,flann,calib3d,videoio,video,highgui \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=OFF \
        -DBUILD_PROTOBUFF=OFF \
        -DWITH_ADE=OFF \
        -DWITH_GSTREAMER=OFF \
        -DWITH_FFMPEG=ON \
        -DBUILD_JPEG=ON \
        -DWITH_PROTOBUF=OFF \
        -DWITH_GTK=ON

    else 
      return 1
    fi

    cmake --build ./build/Linux/opencv/$ARCH --verbose
    cmake --install ./build/Linux/opencv/$ARCH --prefix ./$ARCH
  
  done

  # rm -rf ./opencv
}

install_opencv_linux

popd > /dev/null
