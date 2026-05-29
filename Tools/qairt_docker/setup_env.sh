#============================================================================
# Copyright (c) 2024 Qualcomm Innovation Center, Inc. All rights reserved.
# SPDX-License-Identifier: BSD-3-Clause-Clear
#============================================================================

#!/bin/bash
# setup_env.sh
# - First run (docker build): performs full one-time setup, creates a marker file.
# - Subsequent runs (every new shell): lightweight env activation only.

MARKER="/Tools/qairt_docker/.env_initialized"

# ─── lightweight path: activate env on every shell open ──────────────────────
if [[ -f "${MARKER}" ]]; then
    source /usr/venv/bin/activate
    source ${QAIRT_SDK_ROOT}/bin/envsetup.sh
    export PATH=/usr/venv/lib/python3.10/site-packages/tensorflow:${PATH}
    export PATH=/usr/venv/lib/python3.10/site-packages/onnx:${PATH}
    export TENSORFLOW_HOME=/usr/venv/lib/python3.10/site-packages/tensorflow
    return 0 2>/dev/null || exit 0
fi

# ─── first-time (build-time) full setup below ────────────────────────────────

function downloadndk() {
	mkdir -p /Tools/qairt_docker/android_ndk
	wget https://dl.google.com/android/repository/android-ndk-r26c-linux.zip -O /tmp/android-ndk-r26c-linux.zip
	unzip /tmp/android-ndk-r26c-linux.zip -d /Tools/qairt_docker/android_ndk
	rm /tmp/android-ndk-r26c-linux.zip
	export ANDROID_NDK_ROOT=/Tools/qairt_docker/android_ndk/android-ndk-r26c
	export PATH=${ANDROID_NDK_ROOT}:${PATH}
	${QAIRT_SDK_ROOT}/bin/envcheck -n
}

function predownloadedndk() {
	read -p "Do you have Android NDK (android-ndk-r26c-linux.zip) already downloaded? Select [Y]es or [N]o " downloaded_ndk
	case $downloaded_ndk in
		[Yy]* )
			read -p "Please provide the android ndk path: " ndk_path
			export ANDROID_NDK_ROOT=${ndk_path}
			export PATH=${ANDROID_NDK_ROOT}:${PATH}
			${QAIRT_SDK_ROOT}/bin/envcheck -n
			;;
		[Nn]* )
			echo "Skipping the setup of Android NDK";;
        * )
			echo "Please answer yes or no.";;
	esac
}

function setupenv() {
	source /usr/venv/bin/activate
    source ${QAIRT_SDK_ROOT}/bin/envsetup.sh

    # Linux and Python deps are installed by the dockerfile before this script runs.
    # Run envcheck to confirm everything is in order.
    echo -e "\n Verifying environment \n"
    ${QAIRT_SDK_ROOT}/bin/envcheck -c

    echo -e "\n Python dependency report \n"
	python ${QAIRT_SDK_ROOT}/bin/check-python-dependency

	export PATH=/usr/venv/lib/python3.10/site-packages/tensorflow:${PATH}
	export PATH=/usr/venv/lib/python3.10/site-packages/onnx:${PATH}
	export TENSORFLOW_HOME=/usr/venv/lib/python3.10/site-packages/tensorflow

    echo -e "\n Setting up Android NDK \n"
	if [[ -z "${ANDROID_NDK_ROOT}" ]]; then
		read -p "Do you wish to download Android NDK (android-ndk-r26c-linux.zip)? Select [Y]es or [N]o " ndk
		case $ndk in
			[Yy]* )
				downloadndk ;;
			[Nn]* )
				predownloadedndk;;
			* )
				echo "Please answer yes or no.";;
		esac
	else
		echo "Android NDK path is already set to $ANDROID_NDK_ROOT"
	fi
}

function setupoptionalenv() {
	if [[ -z "${HEXAGON_SDK_ROOT}" ]]; then
		read -p "(optional) Do you wish to set up Hexagon toolchain? Select [Y]es or [N]o " hex
		case $hex in
			[Yy]* )
				read -p "Please provide the Hexagon toolchain path: " hex_path
				export HEXAGON_SDK_ROOT=${hex_path} ;;
			[Nn]* )
				echo "Skipping setting the hexagon SDK path, This is optional setup";;
			* )
				echo "Please answer yes or no.";;
		esac
	fi

	if [[ -z "${QNX_HOST}" ]]; then
		read -p "(optional) Do you wish to set up QNX toolchain? Select [Y]es or [N]o " qnx
		case $qnx in
			[Yy]* )
				read -p "Please provide the QNX toolchain path: " qnx_path
				export QNX_HOST=${qnx_path}/root/host
				export QNX_TARGET=${qnx_path}/root/target
				export PATH=${QNX_HOST}/usr/bin:${PATH} ;;
			[Nn]* )
				echo "Skipping setting the QNX toolchain path. This is optional setup";;
			* )
				echo "Please answer yes or no.";;
		esac
	fi

	if [[ -z "${QNN_AARCH64_LINUX_OE_GCC_93}" ]]; then
		read -p "(optional) Do you wish to set up OE-Linux toolchain? Select [Y]es or [N]o " oe
		case $oe in
			[Yy]* )
				read -p "Please provide the OE-Linux toolchain path: " oe_path
				export QNN_AARCH64_LINUX_OE_GCC_93=${oe_path} ;;
			[Nn]* )
				echo "Skipping setting the OE-Linux toolchain path. This is optional setup";;
			* )
				echo "Please answer yes or no.";;
		esac
	fi
}

# ─── resolve QAIRT SDK path ───────────────────────────────────────────────────
if [[ -z "${QAIRT_SDK_ROOT}" ]]; then
	read -p "Enter the path of QAIRT SDK: " sdk_path
	export QAIRT_SDK_ROOT=${sdk_path}
else
	echo -e "\n Using pre-installed QAIRT SDK at $QAIRT_SDK_ROOT \n"
fi

echo -e "\n Running one-time SDK environment setup \n"
setupenv
# setupoptionalenv

# ─── persist env vars to .bashrc (written once) ──────────────────────────────
{
    echo "export QAIRT_SDK_ROOT=${QAIRT_SDK_ROOT}"
    echo "export ANDROID_NDK_ROOT=${ANDROID_NDK_ROOT}"
    [[ -n "${HEXAGON_SDK_ROOT}" ]] && echo "export HEXAGON_SDK_ROOT=${HEXAGON_SDK_ROOT}"
    echo ". /setup_env.sh"
} > ~/.bashrc

echo "SDK path: $QAIRT_SDK_ROOT"
echo "NDK path: $ANDROID_NDK_ROOT"

# ─── create marker so future shells use the lightweight path ─────────────────
touch "${MARKER}"
echo -e "\n Environment setup complete. Future shells will activate instantly.\n"
