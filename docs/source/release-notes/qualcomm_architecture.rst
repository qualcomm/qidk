Snapdragon SoC Architecture
==============================================

Snapdragon Mobile Processor is a heterogeneous SoC where CPU, GPU, NPU, ISP and connectivity are tightly coupled through high bandwidth interconnects to deliver performance per watt and real time experiences.

.. image:: /_static/Qualcomm_SoC_Archiecture.jpg
   :width: 350px
   :align: center

1. Qualcomm® Oryon™ CPU
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Role: General purpose processing & system control

Qualcomm Oryon CPU is a custom-built CPU architecture designed by Qualcomm for high performance and high efficiency mobile computing. It handles:

- Application execution (Android framework, apps, services)
- System scheduling and OS control
- Control logic for camera, AI, graphics, and connectivity pipelines

2. Qualcomm® Adreno™ GPU
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Role: Graphics rendering & parallel compute

The Adreno GPU is Qualcomm’s in house graphics processor, responsible for:

- UI composition and display rendering
- Advanced mobile gaming (Vulkan, OpenGL ES)
- GPU compute for graphics adjacent workloads
- Hardware accelerated ray tracing and gaming features

3. Qualcomm® Hexagon™ NPU
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Role: AI & Machine Learning acceleration

The Hexagon NPU (Neural Processing Unit) is Qualcomm’s dedicated AI engine, optimized for:

Neural network inference
- On device generative AI
- Computer vision and speech processing
- Sensor driven AI workloads

Qualcomm explains that Hexagon combines tensor, vector, and scalar accelerators in a fused architecture, enabling efficient execution of AI models with lower power consumption compared to CPU or GPU execution.

4. Qualcomm® Spectra™ ISP (Image Signal Processor)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Role: Camera & Imaging Processing

The Spectra ISP is Qualcomm’s dedicated camera processing block. It processes raw sensor data and performs:

- Demosaicing and noise reduction
- Auto exposure, auto white balance, autofocus
- Multi frame HDR and Night Vision
- AI assisted image enhancement (via Hexagon)

5. Qualcomm® Sensing Hub
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Role: Low-power always-on contextual awareness & sensor processing

The Qualcomm Sensing Hub is a dedicated, low-power subsystem designed to efficiently process continuous data streams from various sensors and peripherals without waking the main CPU. It handles:

- Always-on sensor algorithms (e.g., pedometer, activity recognition, motion and elevator detection)
- Always-on audio processing for seamless voice wake-up, keyword detection, and audio context awareness
- Always-Sensing Camera (ASC) workloads for ultra-low-power face detection and vision tasks
- Supplying machine learning inputs and contextual data to proactive on-device AI assistants

6. Qualcomm® Connectivity Subsystem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Role: Connectivity

Snapdragon mobile platforms integrate cellular and short range connectivity directly into the SoC through the Snapdragon Modem RF system and FastConnect™ subsystems. 

- Cellular: 5G modem and RF transceivers
- FastConnect subsystem: Wi Fi, Bluetooth, and Ultra Wideband (UWB)
