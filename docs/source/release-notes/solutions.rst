Solutions
==========

Generic Android Application Architecture
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

The Android application is designed with a clear separation of architectural responsibilities:

- Java/Kotlin → UI, Camera/Audio integration, Lifecycle management
- JNI → Minimal bridging layer between managed and native code
- C++ → Pre‑processing, Inference, and Post‑processing logic
- QAIRT SDK → Execution and hardware acceleration on CPU, GPU, or DSP using SNPE/QNN/GENIE APIs

.. image:: /_static/Android_App_Arechiecture.png
   :width: 250px
   :align: center

Detailed Stage Breakdown
------------------------

1. Java Layer (Application Logic)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Responsibilities:

- Camera capture (Android Camera2 API / CameraX)
- Frame acquisition (Bitmap / YUV)
- UI rendering (bounding boxes, labels)
- Threading & lifecycle

Typical data passed to JNI:

- Image buffer - Frame width / height, format
- User Prompt
- Hardware acceleration (CPU / GPU / DSP)

Receiving data from Native Layer:

- Post process detection outputs (bounding boxes, class labels, and confidence scores) and map results to screen coordinates
- Text/Image/Audio from GenAI

2. JNI Layer (Bridge Only)
~~~~~~~~~~~~~~~~~~~~~~~~~~

Responsibilities:

- Minimal logic
- Data marshaling only
- No preprocessing or math

JNI exists to:

- Avoid SDK dependency in Java
- Keep performance-critical logic native

3. C++ Processing
~~~~~~~~~~~~~~~~~~~~

Preprocessing:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Responsibilities:

- Resize to model input size
- Color conversion (YUV → RGB)
- Normalization / scaling
- Tensor layout conversion

This stage ensures:

- Input matches model expectations exactly

Inference:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Responsibilities:

- Load model once at startup
- Select runtime (CPU / GPU / DSP)
- Allocate buffers
- Execute inference per frame

This stage uses:

- SNPE APIs
- QNN APIs
- Genie APIs

Postprocessing:
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Responsibilities:

- Decode raw output tensors
- Apply confidence thresholds
- Perform NMS (if needed)
- Convert model output → objects

Produces:

- Bounding boxes, Class IDs, Confidence scores for Object Detection Models
- Text for NLP


Why This Architecture Works Well
--------------------------------

- **Performance**: Heavy work stays native
- **Portability**: Swap models without UI changes
- **Scalability**: Same flow for detection, segmentation, pose


QIDK Solutions
""""""""""""""""""""""""""""""

This document describes all end-to-end AI solutions provided in the
Qualcomm Innovators Development Kit (QIDK). Solutions are grouped based
on the AI stack used: SNPE, QNN, and GenAI (GENIE).


SNPE Solutions
----------------

NLPSolution1 – Question Answering
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  End-to-end Question Answering pipeline demonstrating on-device NLP
  inference using Qualcomm AI accelerators.

**Model Used**
  * ELECTRA – Question Answering

**Model On-boarding**
  * `ELECTRA Model On-boarding <https://github.com/quic/qidk/tree/master/Solutions/NLPSolution1-QuestionAnswering>`_

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/NLPSolution1-QuestionAnswering/QuestionAnswering

NLPSolution2 – Sentiment Analysis
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  Sentiment analysis example showcasing NLP inference optimized for
  Snapdragon platforms.

**Model Used**
  * MobileBERT – Sentiment Classification

**Model On-boarding**
  * `MobileBERT Model On-boarding <https://github.com/quic/qidk/tree/master/Solutions/NLPSolution2-SentimentAnalysis>`_

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/NLPSolution2-SentimentAnalysis/SentimentAnalysis


NLPSolution3 – Automatic Speech Recognition (Whisper)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  Automatic Speech Recognition pipeline running fully on-device using
  Whisper and Qualcomm AI accelerators.

**Model Used**
  * Whisper – Automatic Speech Recognition

**Model On-boarding**
  * `ASR Whisper Model On-boarding <https://github.com/quic/qidk/blob/master/Solutions/NLPSolution3-AutomaticSpeechRecognition-Whisper/Generate_Assets/whisper_notebook.ipynb>`_ 

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/NLPSolution3-AutomaticSpeechRecognition-Whisper/Android_App_Whisper

VisionSolution1 – Object Detection (YOLO NAS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  High-performance object detection using YOLO NAS optimized for
  mobile AI acceleration.

**Model Used**
  * YOLO NAS

**Model On-boarding**
  * `YOLONAS Model On-boarding <https://github.com/quic/qidk/blob/master/Solutions/VisionSolution1-ObjectDetection-YoloNas/GenerateDLC.ipynb>`_ 

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/VisionSolution1-ObjectDetection-YoloNas/app


VisionSolution1 – Object Detection (DETR)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  Transformer-based object detection using DETR on Snapdragon platforms.

**Model Used**
  * DETR – Detection Transformer

**Model On-boarding**
  * `DETR Model On-boarding <https://github.com/quic/qidk/blob/master/Solutions/VisionSolution1-ObjectDetection-DETR/GenerateDLC.ipynb>`_ 

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/VisionSolution1-ObjectDetection-DETR/app


VisionSolution2 – Image Super Resolution
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  Image super-resolution pipeline optimized for on-device inference.

**Model Used**
  * SESR – Single Image Efficient Super Resolution

**Model On-boarding**
  * `SESR Model On-boarding Notebook <https://github.com/quic/qidk/blob/master/Solutions/VisionSolution2-ImageSuperResolution/Genarate_Model/sesr.ipynb>`_
    

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/VisionSolution2-ImageSuperResolution/superresolution

VisionSolution3 – Image Enhancement
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  Image enhancement solution focusing on low-light and visual quality
  improvement.

**Model Used**
  * EnlightenGAN – Image Enhancement

**Model On-boarding**
  * `EnlightenGAN Model On-boarding <https://github.com/quic/qidk/tree/master/Solutions/VisionSolution3-ImageEnhancement>`_

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/VisionSolution3-ImageEnhancement/enhancement

VisionSolution4 – Pose Estimation
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  Human pose estimation pipeline optimized for Snapdragon devices.

**Model Used**
  * HRNet – Human Pose Estimation

**Model On-boarding**
  * `HRNet Model On-boarding Notebook <https://github.com/quic/qidk/blob/master/Solutions/VisionSolution4-PoseEstimation/Generate_models/GenerateDLC.ipynb>`_

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/VisionSolution4-PoseEstimation

QNN Solutions
----------------

VisionSolution1 – Object Detection (QNN based YOLO NAS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

**Description**
  YOLONAS object detection implemented using Qualcomm AI Engine Direct (QNN).

**Model Used**
  * YOLONAS

**Model On-boarding**
  * `YOLONAS Model On-boarding Notebook <https://github.com/quic/qidk/blob/master/Solutions/QNN/VisionSolution1-ObjectDetection-YoloNas/GenerateQNNSharedLibrary.ipynb>`_

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/QNN/VisionSolution1-ObjectDetection-YoloNas/app



GenAI Solutions
-----------------

AI Assistant
~~~~~~~~~~~~

**Description**
  AI Assistant is an on-device GenAI chat application that acts as an AI
  companion, enabling natural language interaction and task assistance.
  The solution demonstrates how to integrate and accelerate Large Language
  Models (LLMs) on Snapdragon platforms using GENIE and QAIRT APIs.

**Model Used**
  * LLaMA family of Large Language Models (LLMs)

**Model On-boarding**
  * LLM models are sourced from Qualcomm AI Hub and Hugging Face
  * Context binaries are generated using GENIE export flows as described in: `LLaMA Model On-boarding from AI Hub <https://github.com/quic/ai-hub-apps/tree/main/tutorials/llm_on_genie>`_
  

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/GenAI/AI-Assistant/app


Speech to Image
~~~~~~~~~~~~~~~

**Description**
  Speech to Image is a multimodal GenAI application that converts spoken
  input into image outputs fully on-device. The solution demonstrates
  speech understanding followed by generative image synthesis using
  Qualcomm GenAI acceleration.

**Model Used**
  * Automatic Speech Recognition model (Speech Encoder)
  * Text to Image Generative Model (Diffusion based)

**Model On-boarding**
  * ASR and generative models are downloaded from Qualcomm AI Hub and QPM tutorials 
  * `ASR (Whisper Tiny) and Stable Diffusion Model (QPM tutorials) On-boarding <https://github.com/quic/qidk/tree/master/Solutions/GenAI/speech_to_image>`_

**Android App Source Code**
  * https://github.com/quic/qidk/tree/master/Solutions/GenAI/speech_to_image/speech_to_image