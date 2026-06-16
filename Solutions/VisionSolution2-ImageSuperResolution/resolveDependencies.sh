#============================================================================
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#============================================================================

#RESOLVING DEPENDENCIES

# Check if QAIRT_SDK_ROOT is set ?
[ -z "$QAIRT_SDK_ROOT" ] && echo "QAIRT_SDK_ROOT not set" && exit -1 || echo "QAIRT_SDK_ROOT = ${QAIRT_SDK_ROOT}"

# Copy snpe-release.aar from Qualcomm AI Runtime (QAIRT) SDK
mkdir -p snpe-release
cp $QAIRT_SDK_ROOT/lib/android/snpe-release.aar snpe-release

# Copy DLC model generated from the notebook
mkdir -p superresolution/src/main/assets
cp -R Genarate_Model/models/*.dlc ./superresolution/src/main/assets/
