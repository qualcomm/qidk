#!/bin/bash
#============================================================================
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#============================================================================

# RESOLVING DEPENDENCIES
# Run this script from within the Android_App_Whisper directory.

# Check if QAIRT_SDK_ROOT is set
[ -z "$QAIRT_SDK_ROOT" ] && echo "QAIRT_SDK_ROOT not set" && exit -1 || echo "QAIRT_SDK_ROOT = ${QAIRT_SDK_ROOT}"

# Copy SNPE header files to App CPP include directory
mkdir -p ./app/src/main/cpp/inc/zdl/
cp -R $QAIRT_SDK_ROOT/include/SNPE/* ./app/src/main/cpp/inc/zdl/

# Extract snpe-release.aar and copy JNI libraries
mkdir -p snpe-release
cp $QAIRT_SDK_ROOT/lib/android/snpe-release.aar snpe-release/
unzip -o snpe-release/snpe-release.aar -d snpe-release/snpe-release

mkdir -p app/src/main/jniLibs/arm64-v8a

cp snpe-release/snpe-release/jni/arm64-v8a/libSNPE.so             app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libsnpe-android.so     app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpPrepare.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV73Skel.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV73Stub.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV75Skel.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV75Stub.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV79Skel.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV79Stub.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV81Skel.so   app/src/main/jniLibs/arm64-v8a/
cp snpe-release/snpe-release/jni/arm64-v8a/libSnpeHtpV81Stub.so   app/src/main/jniLibs/arm64-v8a/

# Copy libSNPE.so to cmakeLibs for CMake linking
mkdir -p app/src/main/cmakeLibs/arm64-v8a
cp app/src/main/jniLibs/arm64-v8a/libSNPE.so app/src/main/cmakeLibs/arm64-v8a/

# Copy generated DLC and TFLite decoder model to assets and ml directories
mkdir -p app/src/main/assets
mkdir -p app/src/main/ml
cp ../Generate_Assets/*.dlc app/src/main/assets/
cp ../Generate_Assets/*.dlc app/src/main/ml/
cp ../Generate_Assets/openai-whisper/models/whisper-decoder-tiny.tflite app/src/main/assets/
cp ../Generate_Assets/openai-whisper/models/whisper-decoder-tiny.tflite app/src/main/ml/
