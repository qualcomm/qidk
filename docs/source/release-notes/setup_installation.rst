Setup & Installation
====================

Prerequisites
-------------
- Ubuntu 22.04
- Internet access

QIDK Repository
------------------
Clone QIDK into your Ubuntu 22.04 workspace.

.. code-block:: bash

   git clone https://github.com/quic/qidk.git

QAIRT SDK
-------------
The Docker setup automatically installs **QAIRT SDK v2.47.0.260601** by default.

To use a different version, download it from the `Qualcomm AI Runtime Community <https://softwarecenter.qualcomm.com/catalog/item/Qualcomm_AI_Runtime_Community>`_ portal,
extract the package, and set ``QAIRT_SDK_ROOT`` before running the script:

.. code-block:: bash

   export QAIRT_SDK_ROOT=<absolute_path_to_extracted_sdk>

Docker Setup and Installation
-----------------------------

The ``run_qairt_docker.sh`` script provides a ready-to-use development environment
with the QAIRT SDK, Android NDK, and Python ML frameworks (TensorFlow, PyTorch, ONNX)
pre-installed and configured.

Navigate to the Docker directory inside the cloned repository::

   cd qidk/Tools/qairt_docker

Run the setup script
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

::

   ./run_qairt_docker.sh

The script handles everything automatically:

- **First run:** builds the Docker image, downloading QAIRT SDK v2.47.0.260601
  and Android NDK r26c. Takes 30+ minutes depending on internet speed.
- **Subsequent runs:** detects the existing image and skips the build. Starts in seconds.
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

Inside the Container
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The shell opens automatically in the ``qidk/`` directory with the environment
fully activated — no manual steps needed:

- Python virtual environment is active
- ``QAIRT_SDK_ROOT`` points to the installed QAIRT SDK
- ``ANDROID_NDK_ROOT`` points to Android NDK r26c
- All QAIRT tools are available on ``PATH``

Verify the setup::

   echo $QAIRT_SDK_ROOT
   qnn-net-run --version

Type ``exit`` to leave the container. Run ``./run_qairt_docker.sh`` again at any
time to re-enter.

Installing Additional Python Packages
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Each model solution may require additional Python packages. Install them inside the container based on the requirements of the model you are working with:

.. code-block:: bash

   pip install <package_name>



Stopping and Removing the Container (Optional)
-----------------------------------------------

These steps are **optional** and only required if you want to clean up Docker resources.

List all containers
~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker ps -a

Stop a container
~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker stop <CONTAINER_ID>

Remove the container
~~~~~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker rm <CONTAINER_ID>



Removing the Docker Image (Optional)
------------------------------------

List all images
~~~~~~~~~~~~~~~

.. code-block:: bash

   docker images

Remove the image
~~~~~~~~~~~~~~~~

.. code-block:: bash

   docker rmi -f <IMAGE_ID>


