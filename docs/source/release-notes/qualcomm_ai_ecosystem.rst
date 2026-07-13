Qualcomm AI Ecosystem
------------------------------------

The Qualcomm AI software stack relies on two primary ecosystems:

* Qualcomm AI Runtime (QAIRT) provides multiple paths through that flow. The right path depends on the model type, how much hardware control is required, and how much accuracy recovery work is needed after quantization.

* AI Model Efficiency Toolkit (AIMET) for advanced model optimization during the training phase

QAIRT
~~~~~~~~~~~~

This is the on-device execution software (C++ / Java APIs) that actually runs the neural network on the Snapdragon platform. It abstracts the complexities of the underlying silicon (Hexagon NPU/HTP, Adreno GPU, Kryo CPU). It provides three distinct deployment paths (SNPE, QNN, Genie) depending on your model type and the level of hardware control you need.

SNPE (Snapdragon Neural Processing Engine)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* **Purpose and Importance:** It provides a highly abstracted, user-friendly interface that manages memory allocation, graph execution, and hardware delegation automatically across different hardware blocks.
* **When to use it:** Use SNPE for fast, straightforward integration of common Deep Learning workloads (like standard vision or audio classifiers). It uses the unified ``.dlc`` format and requires significantly less low-level tuning from the developer.

QNN (Qualcomm Neural Network)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
* **Purpose and Importance:** It provides explicit, direct control over the underlying hardware—especially the Hexagon Tensor Processor (HTP)—which higher-level APIs abstract away. 
* **When to use it:** Use QNN when you require absolute maximum performance. It is necessary when you must squeeze out every drop of efficiency, write custom hardware operations (custom ops), manage complex multi-context execution, or perform deep, layer-by-layer profiling directly on the hardware.

Genie (Generative AI Inference Engine)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* **Purpose and Importance:** The specialized runtime pipeline for Large Language Models (LLMs) and Generative AI workloads. Genie is a purpose-built abstraction on top of QNN specifically designed to manage autoregressive workloads efficiently.
* **When to use it:** Use Genie when deploying text-generation and chat applications. It handles the complex logic of token generation and KV-caching directly, relying on the QNN HTP backend for the heavy computational lifting without requiring you to write that logic from scratch.

**QAIRT SDK documentation**: https://docs.qualcomm.com/doc/80-63442-10/topic/general_overview.html#supported-snapdragon-devices

AIMET
~~~~~~~~~~~~

**Purpose and Importance:**
AIMET is an open-source model optimization library designed to integrate directly with ML training frameworks such as **PyTorch** and **TensorFlow**. Modern hardware accelerators deliver the best performance and power efficiency when running low-precision integer computations, especially **INT8**. However, converting a high-precision **FP32** model to INT8 often results in significant accuracy degradation.

AIMET addresses this challenge by enabling model compression and quantization while preserving model accuracy as much as possible. It serves as a bridge between high-accuracy training workflows and efficient on-device deployment.

**Why to use it:**

* Restores accuracy lost during standard post-training quantization
* Enables advanced optimization techniques such as Quantization-Aware Training (QAT), AdaRound, and Cross-Layer Equalization (CLE)
* Supports layer sensitivity analysis to identify which parts of a neural network can be quantized safely
* Helps prepare models for efficient deployment on hardware-accelerated and resource-constrained platforms

**AIMET Documentation**: https://quic.github.io/aimet-pages/releases/latest/overview/index.html
