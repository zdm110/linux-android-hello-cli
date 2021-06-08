#!/bin/bash

# specify the arm as abi, the api level for android kitkat as used by
# google tango and with gnustl_static the c++ support
# for more information look into the android.toolchain.cmake file
#export ANDROID_ABI="armeabi-v7a with NEON"
export ANDROID_ABI="arm64-v8a"
export ANDROID_NATIVE_API_LEVEL=android-19
export ANDROID_STL=gnustl_static
export ANDROID_STL_FORCE_FEATURES=ON
export ANDROID_NDK=/opt/android-ndk-r14b

export CFLAGS="-pipe -w"
export CXXFLAGS=${CFLAGS}

# [[ -z "${jobs}" ]] && jobs=$(grep -cP '^processor' /proc/cpuinfo)
jobs=8

# echo -e "\n\n\033[1;32mCompiling with ${jobs} jobs ...\033[m"

# check that ANDROID_NDK points to a android ndk folder

ROOT=${PWD}
ANDROIDTOOLCHAIN=${ROOT}/android.toolchain.cmake


# echo -e "\n\n\033[1;35m###########################################"
# echo -e "### Build DepthCal Lib start...      ###"
# echo -e "###########################################\033[m\n\n"


build_host()
{
  mkdir -p build-linux
  cd build-linux
  rm CMakeCache.txt

  cmake .. -DCMAKE_BUILD_TYPE:STRING=Release

  make -j${jobs}
  cd ../
}

build_android64()
{
  mkdir -p build-android
  cd build-android
  rm CMakeCache.txt
  export ANDROID_ABI="arm64-v8a"

  cmake .. -DCMAKE_BUILD_TYPE:STRING=Release \
    -DCMAKE_TOOLCHAIN_FILE:FILEPATH=$ANDROIDTOOLCHAIN \
    -DANDROID_TOOLCHAIN_NAME=aarch64-linux-android-4.9 \
    -DSUNNY_ABI_NAME:STRING=android-arm64

  make -j${jobs}
  cd ../
}


echo -e "\n
    Make Target:
       *0) Linux-x64
        1) Android ARM64
        Please input your choice[0]:\c"
read choice
#-----------------------------------------
case "$choice" in
    0 | "")
    echo "===========Start building Linux version ..."
    build_host
    ;;
    1)
    echo "===========Start building Android ARM64 version ..."
    build_android64
    ;;
    *)
    echo "Nothing to do ..."
    ;;
esac
