# OnDevice Automatic Speech Recognition

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Model Selection and DLC conversion](#1-model-preparation)
  1. Model Overview
  2. Steps to convert model to DLC
 
- [Build and Run with Android Studio](#4-build-and-run-with-android-studio)
  1. Source Organization
  2. Code implementataion
- [Qualcomm AI Runtime SDK C++ APIs JNI Integration](#qualcomm-neural-processing-sdk-c-apis-jni-integration)
- [Reults](#Result)
- [Credits](#credits)
- [References](#references)

# Introduction

Automatic Speech Recognition (ASR) is one of the common and challenging Natural Language Processing tasks. <br>
- Current project is an sample Android application for OnDevice Automatic Speech Recognition using <b>Qualcomm AI Runtime SDK for AI</b> framework. 
-  We have used [Whisper](https://github.com/openai/whisper) Model in this Solution

- This Solution has 2 Model, Encoder and Decoder Model.
- Encoder(Quantized-a16w8) part is taking fixed size input of shape (1,80,3000) and running on Snapdragon DSP processor.
- Decoder(Fp32) part is taking variable size input and running as TFLite model.
- Model is small, efficient and mobile friendly Transformer model fine-tuned on [librispeech dataset](https://www.tensorflow.org/datasets/catalog/librispeech) for **ASR** downstream task
- In this project, we'll show how to efficiently convert, deploy and acclerate of these model on Snapdragon® platforms to perform Ondevice Automatic Speech Recognition(ASR).

## Model Architecture
<p align="center">
<img src="readme_assets/whisper_architecture.png" width=35% height=35%>
</p>

## Prerequisites
* Android Studio Panda 4 Version 2025.3.4 to import and build the project
* Setup Docker environment by following the instructions in [Tools/qairt_docker](../../Tools/qairt_docker/README.md)


## List of Supported Devices

- Snapdragon 8 Elite Gen5 (SM8850) - NPU Version: V81
- Snapdragon 8 Elite Gen4 (SM8750) - NPU Version: V79
- Snapdragon 8 Gen3 (SM8650) - NPU Version: V75
- Snapdragon 8 Gen2 (SM8550) - NPU Version: V73
  
## Quick Start

### Model Preparation
Please go to Generate_Assets/Whisper_Notebook.ipynb and Generate_Assets/vocab_gen.ipynb file to generate the model and check the sample output,pipeline.
<br>

## Build and run with Android Studio

#### Add AI SDK libs and generated DLC into app assets, jniLibs and cmakeLibs directory:

Run the provided script from within the `Android_App_Whisper` directory to automatically set up all required dependencies:

```java
cd Android_App_Whisper
bash resolveDependencies.sh
```

The script will:
- Copy SNPE header files to `app/src/main/cpp/inc/zdl/`
- Extract `snpe-release.aar` and populate `app/src/main/jniLibs/arm64-v8a/` with all SNPE runtime libraries (V73–V81)
- Copy `libSNPE.so` to `app/src/main/cmakeLibs/arm64-v8a/` for CMake linking
- Copy generated DLC files and the TFLite decoder model to `app/src/main/assets/` and `app/src/main/ml/`

## Build APK file with Android Studio

1. Clone QIDK repo.

2. Use the `Generate_Assets/whisper_notebook.ipynb` notebook to generate the encoder DLC and download the decoder TFLite model, then run `resolveDependencies.sh` to resolve all necessary dependencies (see above).

3. Import folder `Android_App_Whisper` as a project in Android Studio.

4. Compile the project.

5. Output APK file should get generated: `app-debug.apk`

6. Prepare the Qualcomm Innovators development kit to install the application.

7. If Unsigned or Signed DSP runtime is not getting detected, then please check the logcat logs for the FastRPC error. DSP runtime may not get detected due to SE Linux security policy. Please try out following commands to set permissive SE Linux policy.

```java
adb disable-verity
adb reboot
adb root
adb remount
adb shell setenforce 0
```

8. Install and test application:
```java
adb install -r -t app-debug.apk
```

9. Launch the application.

# Result

<p align="center">
<img src="readme_assets/IMG_4734 - Trim.gif" width=65% height=65%>
</p>

#### Debug Tips
* After installing the application, if it is crashing, try to collect the logs from QIDK device.
* To collect logs run the below commands.
	*	adb logcat -c
	* adb logcat > log.txt
	*	Now, run the app. Once, the app has crashed do Ctrl+C to terminate log collection.
	*	log.txt will be generated in current folder.
	*	Search for the keyword "crash" to analyze the error.

* On opening the app, if Unsigned or Signed DSP runtime is not getting detected, then please search the logcat logs with keywork `dsp` for the FastRPC errors.
* DSP runtime may not get detected due to SE Linux security policy in some Android builds. Please try out following commands to set `permissive` SE Linux policy.
```
adb disable-verity
adb reboot
adb root
adb remount
adb shell setenforce 0
// launch the application
```

## Credits

The pre-trained model is from HuggingFace Repo
- Pre and Post processing is taken from this repo [link](https://github.com/usefulsensors/openai-whisper)/android app.
- Encoder Model is taken from this repo [link](https://github.com/openai/whisper.git) , please follow the procedure mentioned in whisper_notebook.
- Pretrained TFLIte Decoder Model is taken from this repo [link](https://github.com/usefulsensors/openai-whisper).


## References

- https://github.com/usefulsensors/openai-whisper
- https://github.com/openai/whisper.git 
- https://openai.com/research/whisper
- https://huggingface.co/openai/whisper-tiny
- https://www.tensorflow.org/datasets/catalog/librispeech
- https://docs.qualcomm.com/bundle/publicresource/topics/80-63442-2/setup.html?product=1601111740010412
- https://docs.qualcomm.com/bundle/publicresource/topics/80-63442-2/cplus_plus_tutorial.html?product=1601111740010412
- https://docs.qualcomm.com/bundle/publicresource/topics/80-63442-2/benchmarking.html?product=1601111740010412


###### *Qualcomm Neural Processing SDK is a product of Qualcomm Technologies, Inc. and/or its subsidiaries.*
