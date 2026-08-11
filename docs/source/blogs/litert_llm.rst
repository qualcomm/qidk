.. _litert-llm:

Deploying LLMs on Qualcomm NPU using LiteRT LM
================================================

.. contents:: On this page
   :depth: 2
   :local:

----

Overview
--------

`LiteRT LM <https://github.com/google-ai-edge/litert-samples/tree/main/compiled_model_api/qualcomm/llm_chatbot_npu>`_
is Google's on-device inference library for large language models. On Qualcomm Snapdragon
devices, it leverages the Hexagon NPU to execute models locally without any cloud connectivity.

This article walks through deploying the LiteRT LM sample Android application on a Snapdragon
device, covering both the command-line and Android Studio deployment paths.

----

The ``.litertlm`` Model Format
--------------------------------

The ``.litertlm`` format is a model binary pre-compiled for a specific Qualcomm chipset by
Qualcomm AI Hub. Unlike general-purpose formats such as ONNX or GGUF, a ``.litertlm`` file
is ready for direct NPU execution — no runtime compilation is required.

.. important::
   Each ``.litertlm`` file targets a single chipset. Download the file that matches your
   device's SoC identifier (e.g. ``sm8750`` for Snapdragon 8 Elite). Loading an incompatible
   file will result in a runtime error.

----

Supported Models
-----------------

.. list-table::
   :header-rows: 1
   :widths: 35 25 40

   * - Model
     - Chipset Target
     - Capabilities
   * - Gemma 4 E2B-it
     - SM8750 (Snapdragon 8 Elite), SM8850 (Snapdragon 8 Elite Gen5)
     - Text chat, voice input
   * - FastVLM-0.5B
     - SM8750 (Snapdragon 8 Elite)
     - Text chat, image understanding

----

Prerequisites
-------------

.. list-table::
   :widths: 30 70

   * - **Device**
     - A device with Snapdragon 8 Elite (SM8750) or Snapdragon 8 Elite Gen5 (SM8850)
   * - **USB Debugging**
     - Enabled under Developer Options on the target device
   * - **Android Studio**
     - Panda 4 (2025.3.4) or newer — `download <https://developer.android.com/studio>`_
   * - **ADB**
     - Included with Android Studio's platform tools
   * - **Git**
     - To clone the sample repository

----

Step 1 — Clone the Sample Repository
--------------------------------------

.. code-block:: bash

   git clone https://github.com/google-ai-edge/litert-samples.git

Navigate to the NPU chatbot project:

.. code-block:: bash

   cd litert-samples/compiled_model_api/qualcomm/llm_chatbot_npu

This directory is a self-contained Android Studio project requiring no source modifications.

----

Step 2 — Download the Model
-----------------------------

Download the ``.litertlm`` file for your device from the corresponding Hugging Face repository.
Ensure the filename matches your device's SoC identifier — for example:

.. code-block:: text

   gemma-4-E2B-it_qualcomm_sm8750.litertlm   # Snapdragon 8 Elite
   FastVLM-0.5B.qualcomm.sm8750.litertlm      # Snapdragon 8 Elite

.. note::
   Model files range from 1 GB to 4 GB. Ensure sufficient storage is available on both the
   host machine and the target device before proceeding.

----

Step 3 — Build and Deploy the Application
------------------------------------------

1. Open Android Studio and select **File → Open**.
2. Navigate to ``litert-samples/compiled_model_api/qualcomm/llm_chatbot_npu`` and click **OK**.
3. Wait for the Gradle sync to complete. Resolve any SDK licence prompts if shown.
4. Connect the target device via USB. Confirm it appears in the device selector toolbar.
5. Select **Run → Run 'app'** (or press **Shift+F10**).
   Android Studio will build the APK and deploy it directly to the connected device.

----

Step 4 — Push the Model to the Device
---------------------------------------

Copy the downloaded ``.litertlm`` file into the application's data directory using ADB:

.. code-block:: bash

   adb push gemma-4-E2B-it_qualcomm_sm8750.litertlm \
     /sdcard/Android/data/com.example.qnn_litertlm_gemma/files/model.litertlm

The application scans this directory at startup and loads any ``.litertlm`` file it finds.
No additional configuration is required.

----

Step 5 — Launch and Verify
----------------------------

Open the application on the device. On first launch, the model is loaded onto the Hexagon NPU,
after which the chat interface becomes available. Submit a text prompt to confirm the model
is responding correctly.

----

Application Capabilities
--------------------------

.. list-table::
   :header-rows: 1
   :widths: 25 50 25

   * - Mode
     - Description
     - Supported Models
   * - **Text Chat**
     - Conversational text input and streamed response output
     - Gemma 4, FastVLM
   * - **Image + Text**
     - Image selected from device gallery with an accompanying text query
     - FastVLM-0.5B
   * - **Voice Input**
     - Microphone-based prompt entry
     - Gemma 4 (2B variant only)

----

----

References
----------

- `LiteRT LM NPU Sample — GitHub <https://github.com/google-ai-edge/litert-samples/tree/main/compiled_model_api/qualcomm/llm_chatbot_npu>`_
- :doc:`../release-notes/solutions`
- :doc:`../release-notes/setup_installation`
