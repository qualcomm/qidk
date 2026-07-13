Frequently Asked Questions
==========================

Device & Platform
-----------------

.. dropdown:: My device is not booting. What should I do?

   First, check if the **Display Card** is properly seated — a loose or incorrectly connected Display Card is a common cause of boot issues. Reseat the card and attempt to power on the device again.

   If the issue persists, contact the Qualcomm QIDK team at `qidk@qti.qualcomm.com <mailto:qidk@qti.qualcomm.com>`_ with the following details:

   - Device model and Snapdragon platform
   - Description of the issue (e.g., stuck on boot logo, no display, not powering on)

   The team will assist you with next steps.

.. dropdown:: ADB is not detecting my device. What should I check?

   - Ensure USB debugging is enabled on the device (**Settings → Developer Options → USB Debugging**)
   - Try a different USB cable or port
   - Run ``adb kill-server && adb start-server`` to reset the ADB daemon
   - Confirm the device appears with ``adb devices``

Build & Gradle
--------------

.. dropdown:: I am getting Gradle build errors. What Android Studio version should I use?

   Gradle and build tool compatibility is tightly coupled to the Android Studio version. Refer to the ``README`` file in the solution directory for the recommended Android Studio version for that specific solution.

   Using a newer or older version than specified may result in Gradle sync failures or dependency resolution errors. If issues persist after switching to the correct version:

   - Invalidate caches: **File → Invalidate Caches / Restart**
   - Delete the ``.gradle`` and ``build`` directories and re-sync the project
   - Ensure ``QAIRT_SDK_ROOT`` is set correctly and ``resolveDependencies.sh`` has been run
