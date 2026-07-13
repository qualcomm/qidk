============================
Quick Start Guide
============================

Prerequisites
-------------

- **OS:** Ubuntu 22.04 (host machine)
- **Internet access:** Required to download QAIRT SDK and Android NDK during build
- **Disk space:** At least 18 GB free on the Docker storage partition

This guide covers:

1. Setting up the QAIRT Docker environment on a Ubuntu host
2. Building and deploying QIDK solutions on a Snapdragon device

.. contents:: Table of Contents
   :depth: 2
   :local:

----

Part 1: Docker Environment Setup
=================================

The Docker image provides a ready-to-use environment with the QAIRT SDK,
Android NDK, and Python ML frameworks (TensorFlow, PyTorch, ONNX) all
pre-installed and configured.

Step 1 — Clone the Repository
------------------------------

::

   git clone https://github.com/quic/qidk.git
   cd qidk/Tools/qairt_docker

Step 2 — Run the Setup Script
------------------------------

::

   ./run_qairt_docker.sh

The script handles everything automatically:

- **First run:** builds the Docker image, downloading QAIRT SDK v2.47.0.260601
  and Android NDK r26c inside the image. Takes 30+ minutes depending on internet speed.
- **Subsequent runs:** detects the existing image and skips the build. Starts
  in seconds.
- **Version change:** if the QAIRT SDK version is updated in the dockerfile,
  the script detects the mismatch and rebuilds automatically.

**Script options:**

.. code-block:: text

   -i, --image     NAME    Docker image name          (default: qairt)
   -c, --container NAME    Docker container name      (default: qairt_container)
   -m, --mount     PATH    Host directory to expose   (default: /local/)
   -t, --target    PATH    Path inside container      (default: /local/)
   --rebuild               Force rebuild of the image
   --no-cache              Force full rebuild with no Docker layer cache

Step 3 — Inside the Container
------------------------------

The shell opens automatically in the ``qidk/`` directory. The environment
is fully activated — no manual steps needed:

- Python virtual environment is active
- ``QAIRT_SDK_ROOT`` points to the installed QAIRT SDK
- ``ANDROID_NDK_ROOT`` points to Android NDK r26c
- All QAIRT tools are available on ``PATH``

Verify::

   echo $QAIRT_SDK_ROOT
   qnn-net-run --version

Type ``exit`` to leave the container. Run ``./run_qairt_docker.sh`` again
at any time to re-enter.

----

Part 2: Building and Deploying Solutions
=========================================

QIDK provides ready-to-use Android solutions under the ``Solutions/`` and
``GenAI-Solutions/`` directories. Each solution targets Snapdragon hardware
and uses the QAIRT SDK for on-device AI inference.

Overview
--------

The general workflow for any solution is:

1. **Generate models** — convert and quantize AI/ML models to DLC format inside the Docker container
2. **Resolve dependencies** — set up the Android project with required SDK libraries
3. **Build the APK** — compile using Android Studio
4. **Deploy to device** — install and run on a Snapdragon device

Available Solutions
-------------------

.. list-table::
   :header-rows: 1
   :widths: 35 65

   * - Solution
     - Description
   * - VisionSolution1–3
     - Object detection and classification using QAIRT Java API
   * - VisionSolution4-PoseEstimation
     - Human pose estimation using YoloNAS + HRNET (native C++ API)
   * - NLP solutions
     - Natural language processing using QAIRT native API
   * - GenAI-Solutions
     - Generative AI apps — LLaMA, Whisper, Stable Diffusion

Step 1 — Generate Model Files (inside Docker)
----------------------------------------------

Each solution includes a ``Generate_models/`` directory with a Jupyter notebook
to convert and quantize models to DLC format.

Inside the container::

   cd Solutions/<SolutionName>/Generate_models
   jupyter notebook --ip=0.0.0.0 --no-browser --allow-root

Open the notebook in your browser, set any required dataset paths, and run
all cells. The notebook generates the ``.dlc`` model files and copies them
to ``app/src/main/assets/`` automatically.

Step 2 — Resolve Android Project Dependencies
----------------------------------------------

On the **host machine**, set ``QAIRT_SDK_ROOT`` to the SDK path::

   export QAIRT_SDK_ROOT=/path/to/qairt/2.47.0.260601

Navigate to the solution and run::

   cd Solutions/<SolutionName>
   bash resolveDependencies.sh

This downloads OpenCV, copies QAIRT headers and the required ``.so`` libraries
for the target device into the Android project.

Step 3 — Build the APK
-----------------------

Open the solution in Android Studio::

   File → Open → Solutions/<SolutionName>

1. Wait for Gradle sync to complete
2. Select **Build → Make Project**
3. Output APK: ``app/build/outputs/apk/debug/app-debug.apk``

Step 4 — Prepare the Device
----------------------------

Connect the Snapdragon device via USB and run::

   adb disable-verity
   adb reboot
   adb root
   adb remount
   adb shell setenforce 0

.. note::

   ``setenforce 0`` sets SELinux to permissive mode, required to enable the
   HTP (DSP) runtime. Without this the app falls back to CPU.

Step 5 — Install and Run
-------------------------

Install the APK::

   adb install -r -t app/build/outputs/apk/debug/app-debug.apk

Once installed, open the app directly from the device app drawer.
On first launch, grant the required permissions (camera, storage) when prompted.

Runtime Selection
-----------------

All solutions support switching between runtimes from within the app UI:

- **CPU** — runs on the application processor, baseline performance
- **GPU** — uses the Adreno GPU, faster than CPU
- **DSP (HTP)** — uses the Hexagon processor, best performance and efficiency

On Snapdragon 8 Elite (SM8750), the DSP (HTP V79) runtime delivers the
lowest latency and highest power efficiency.

Troubleshooting
---------------

**DSP runtime not detected**
   Ensure ``setenforce 0`` is applied after every reboot::

      adb root && adb shell setenforce 0

   Check logcat for FastRPC errors::

      adb logcat | grep -i "fastrpc\|dsp\|htp"

**Build fails with missing .so files**
   Re-run ``resolveDependencies.sh`` and confirm ``QAIRT_SDK_ROOT`` is set to
   version 2.47.0.260601 or later.

**App crashes on launch**
   Verify the ``.dlc`` model files are present in ``app/src/main/assets/``
   and were copied correctly by the model generation notebook.
