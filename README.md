![Screenshot](./images/logo-quic-on@h68.png)

# Qualcomm® Innovators Development Kit - QIDK

Qualcomm® Innovators Development Kit (QIDK) provides sample applications to demonstrate the capability of Hardware Accelerators for AI, and Software AI stack.

This repository contains sample android applications, which are designed to use components from the following products:

1. [Qualcomm AI Runtime (QAIRT)](https://softwarecenter.qualcomm.com/catalog/item/Qualcomm_AI_Runtime_SDK?osArch=X86&osType=Windows&version=2.46.0.260424)
   Includes Neural Processing SDK (SNPE) and AI Engine Direct (QNN)
2. [AI Model Efficiency Tool Kit (AIMET)](https://github.com/quic/aimet)
3. [AIMET Model Zoo](https://github.com/quic/aimet-model-zoo)
4. [Android Studio](https://developer.android.com/studio/archive)
   The recommended version of Android Studio varies by solution:
   - **Dolphin Version 2021.3.1** for most Solutions (NLP, Vision - Object Detection, Super Resolution, Image Enhancement, Detection Transformer)
   - **Panda 4 Version 2025.3.4** for Pose Estimation
   - **Meerkat 2024.3.1** for all GenAI Solutions

Contents of this repository are verified on Snapdragon 8 Gen2, Snapdragon 8 Gen3, Snapdragon 8 Elite, Snapdragon 8 Elite Gen5 platforms. 
If users want to try this content on other Qualcomm platforms - please do check with the support e-mail mentioned below. 

This Repository is divided into following categories

## QWA Course - AI on Qualcomm Innovators Development Kit 

Qualcomm Wireless Academy has a free course on "AI on Qualcomm Innovators Development Kit".<br><br>
Course Link : https://qwa.qualcomm.com/course-catalog/AI-on-QIDK

This course is geared toward AI application developers, university students, and AI enthusiasts.
This course is applicable, even if a developer is AI SDK on Qualcomm platforms other than QIDK. 

All QIDK deliverables are covered in this course in detail with hands-on lab sessions. 

### Download AI SDK 

Please note the change in steps to download AI SDK (Steps in QWA course will be modified later)
Users need to follow below procedure do download AI SDK. 
1. Download SDK from this link https://softwarecenter.qualcomm.com/catalog/item/Qualcomm_AI_Runtime_SDK?osArch=X86&osType=Windows&version=2.46.0.260424

Or

1. Visit qpm.qualcomm.com
2. Download AI SDK for Linux (Linux is the host platform for development, QIDK has Android as target platform)

   ![image](https://github.com/user-attachments/assets/dbea8590-1af4-496b-8332-81d1f5640401)


4. Follow SDK documentation for setup, or refer to QWA course.
5. Once SDK is setup, please revert back to QWA course for model conversion, and deployment. 

## Examples

Contain examples to use features of above SDKs

|   Type    | SDK   |   Details   |   Link |
|  :---:    |    :---:   |    :---:  |   :---:  |
|  Model    | Qualcomm AI Runtime (QAIRT) |  Model - EnhancementGAN | [ReadMe](./Examples/QNN-Model-Example-EnhancementGAN/README.md) |
|  Model    | Qualcomm AI Runtime (QAIRT)  |  Model - SESR | [ReadMe](./Examples/QNN-Model-Example-SESR/README.md) |
| Android App | NA | Python pre/post in Android App | [ReadMe](./Examples/Python-ASR-wav2vec2/README.md) |

## Model Enablement

Contains examples for : 

1. Using models, that are not directly supported with AI SDK
2. Debug Quantizatin accuracy loss

|   Type    | SDK   |   Details   |   Link |
|  :---:    |    :---:   |    :---:  |   :---:  |
| Model Conversion Guide | Qualcomm AI Runtime (QAIRT) | Model-Accuracy-Mixed-Precision | [ReadMe](./Model-Enablement/Model-Accuracy-Mixed-Precision/README.md)|
| Model Conversion Guide | Qualcomm AI Runtime (QAIRT) | Model-Conversion-Layer-Replacement | [ReadMe](./Model-Enablement/Model-Conversion-Layer-Replacement/README.md)|
| Model Conversion Guide | Qualcomm AI Runtime (QAIRT) | Model-Conversion-UDO-SELU | [ReadMe](./Model-Enablement/Model-Conversion-UDO-SELU/README.md)|

## Solutions

Contain end-to-end ready-to-run solutions

|   Type     | Solution   |   SDK   |sdk version|   API   | Model   |   ReadMe |  Demo   | Android Studio |
|  :---:     |    :---:   |    :---:  |    :---:  |    :---:  |    :---:  |   :---:  |  :---:  |  :---:  |
|  NLP       | Question Answering       |  Qualcomm AI Runtime (QAIRT) | v2.40.0 |Native API | Electra-small     |  [ReadMe](./Solutions/NLPSolution1-QuestionAnswering/README.md) |   [Demo](./Solutions/NLPSolution1-QuestionAnswering/README.md#qa-app-workflow)   | Dolphin Version 2021.3.1 |
|  NLP       | Sentiment Analysis       |  Qualcomm AI Runtime (QAIRT) | v2.40.0 | Native API | MobileBERT     |  [ReadMe](./Solutions/NLPSolution2-SentimentAnalysis/README.md)  |   [Demo](./Solutions/NLPSolution2-SentimentAnalysis/README.md#sa-app-workflow)   | Dolphin Version 2021.3.1 |
|  NLP       | ASR  | Qualcomm AI Runtime (QAIRT) | v2.40.0 | Native API | Whisper | [ReadMe](./Solutions/NLPSolution3-AutomaticSpeechRecognition-Whisper/README.md) | [Demo](./Solutions/NLPSolution3-AutomaticSpeechRecognition-Whisper/README.md#Result) | Dolphin Version 2021.3.1 |
|  Vision    | QNN based Object Detection YoloNAS | Qualcomm AI Runtime (QAIRT) | v2.40.0 | Native API | YoloNAS| [ReadMe](./Solutions/QNN/VisionSolution1-ObjectDetection-YoloNas/README.md)| [Demo](./Solutions/QNN/VisionSolution1-ObjectDetection-YoloNas/demo/ObjectDetectYoloNAS.gif)| Dolphin Version 2021.3.1 |
|  Vision    | Object Detection       |  Qualcomm AI Runtime (QAIRT) | v2.10.0 |   Java API  | Mobilenet SSD V2    | [ReadMe](./Solutions/VisionSolution1-ObjectDetection/README.md) |   [Demo](./Solutions/VisionSolution1-ObjectDetection/demo/ObjectDetection-Demo.gif)   | Dolphin Version 2021.3.1 |
|  Vision    | Object Detection YoloNAS | Qualcomm AI Runtime (QAIRT) | v2.40.0 | Native API | YoloNAS| [ReadMe](./Solutions/VisionSolution1-ObjectDetection-YoloNas/README.md)| [Demo](./Solutions/VisionSolution1-ObjectDetection-YoloNas/demo/ObjectDetectYoloNAS.gif)| Dolphin Version 2021.3.1 |
|  Vision    | Image Super Resolution       |Qualcomm AI Runtime (QAIRT) | v2.40.0 |   Java API | SESR XL    | [ReadMe](./Solutions/VisionSolution2-ImageSuperResolution/README.md) |   [Demo](./Solutions/VisionSolution2-ImageSuperResolution/demo/VisionSolution2-ImageSuperResolution.gif)   | Dolphin Version 2021.3.1 |
|  Vision    | Image Enhancement       |Qualcomm AI Runtime (QAIRT) | v2.40.0 |  Java API | EnhancedGAN    | [ReadMe](./Solutions/VisionSolution3-ImageEnhancement/README.md)  |   [Demo](./Solutions/VisionSolution3-ImageEnhancement/demo/VisionSolution3-ImageEnhancement.gif)   | Dolphin Version 2021.3.1 |
|  Vision    | Pose Estimation |Qualcomm AI Runtime (QAIRT)| v2.40.0 | Native API|YoloNAS + HRNet| [ReadMe](./Solutions/VisionSolution4-PoseEstimation/README.md)|[Demo](./Solutions/VisionSolution4-PoseEstimation/demo/PoseDetectionYoloNas.gif)| Panda 4 Version 2025.3.4 |
|  Vision    | Detection Transformer | Qualcomm AI Runtime (QAIRT) | v2.40.0 | Native API | DETR | [ReadMe](./Solutions/VisionSolution1-ObjectDetection-DETR/README.md) | [Demo](./Solutions/VisionSolution1-ObjectDetection-DETR/demo/ObjectDetectDETR.avi)| Dolphin Version 2021.3.1 |

## GenAI-Solutions

Contain end-to-end ready-to-run solutions

|   Type     | Solution   |   SDK   |sdk version|   API   | Model   |   ReadMe |  Demo   | Android Studio |
|  :---:     |    :---:   |    :---:  |    :---:  |    :---:  |    :---:  |   :---:  |  :---:  |  :---:  |
|  GenAI     | AI-Assistant       |  Qualcomm AI Runtime (QAIRT) | v2.40.0 |Native API | llama     |  [ReadMe](./GenAI-Solutions/AI-Assistant/README.md) |   [Demo](./GenAI-Solutions/AI-Assistant/demo/AI-Assistant.gif)   | Meerkat 2024.3.1 |
|  GenAI     | speech_to_image       |  Qualcomm AI Runtime (QAIRT) | v2.40.0 |Native API | ASR, SD-1.5     |  [ReadMe](./GenAI-Solutions/speech_to_image/README.md) |   [Demo](./GenAI-Solutions/speech_to_image/images/demo_app.gif)   | Meerkat 2024.3.1 |
|  GenAI     | ASR-LLM-TTS       |  Qualcomm AI Runtime (QAIRT) | v2.43.0 |Native API | ASR, LLM, TTS     |  [ReadMe](./GenAI-Solutions/ASR-LLM-TTS/README.md) |   [Demo](./GenAI-Solutions/ASR-LLM-TTS/demo_video/asr_llm_tts_demo_video.mov)   | Meerkat 2024.3.1 |

## Tools

Contain tools to simplify workflow

|   Tool    | SDK   | Version   |   Details   |   Link |
|  :---:    |    :---:   |    :---:   |    :---:  |   :---:  |
|  PySNPE   | Qualcomm AI Runtime (QAIRT)  | - |Python Interface to SDK tools | [ReadMe](./Tools/pysnpe_utils/README.md) |
|  qairt_docker    | Qualcomm AI Runtime (QAIRT)  | 2.40.0+ | Docker container for SDK | [ReadMe](./Tools/qairt_docker/README.md) |
|  snpe-helper    | Qualcomm AI Runtime (QAIRT)  |  - |Python wrapper for C++ API | [ReadMe](./Tools/snpe-helper/README.md) |

## Report Issues

All deliverables were periodically verified on latest Qualcomm AI Stack SDK releases. 
Please report any issues in _issues_ section of GitHub repository. 

Pls write to qidk@qti.qualcomm.com for any questions/suggestions

## Team

Qualcomm Innovators Development Kit (QIDK) software repository is a project maintained by Qualcomm Innovation Center, Inc.

## License 

Please see the [LICENSE](LICENSE) for more details.

###### *Qualcomm AI Runtime (QAIRT), and Qualcomm Innovators Development Kit are products of Qualcomm Technologies, Inc. and/or its subsidiaries. AIMET is a product of Qualcomm Innovation Center, Inc.*
