## Object Detection with YoloNAS
The project is designed to utilize the Qualcomm® AI Runtime (QAIRT), a deep learning software from Snapdragon platforms for Object Detection in Android. The Android application can be designed to use any built-in/connected camera to capture the objects and use Machine Learning model to get the prediction/inference and location of the respective objects.

# Pre-requisites

* Setup Docker environment by following the instructions in [Tools/qairt_docker](../../Tools/qairt_docker/README.md)
* Android Studio Panda 4 Version 2025.3.4 to import and build the project
* Android device 6.0 and above which uses below mentioned Snapdragon processors/Snapdragon HDK with display can be used to test the application
* Download CocoDataset 2017 and give its path to Generate_DLC.ipynb. Change variable "dataset_path" in Quantization Section in notebook.

## List of Supported Devices

- Snapdragon 8 Elite Gen5 (SM8850) - NPU Version: V81
- Snapdragon 8 Elite Gen4 (SM8750) - NPU Version: V79
- Snapdragon 8 Gen3 (SM8650) - NPU Version: V75
- Snapdragon 8 Gen2 (SM8550) - NPU Version: V73

The above targets supports the application with CPU, GPU and DSP. For more information on the supported devices, please follow this link 

# Source Overview

## Source Organization

demo : Contains demo GIF

app : Contains source files in standard Android app format

app\src\main\assets : Contains Model binary DLC 

app\src\main\java\com\qc\objectdetectionYoloNas : Application java source code 

app\src\main\cpp : native source code 
  
sdk: Contains openCV sdk

## DLC Generation

Run jupyter notebook GenerateDLC.ipynb. This notebook will generate YoloNAS quantized dlc.

YoloNAS model is trained on COCO dataset for 80 classes of everyday objects.
List of the classes can be found in dataset at : https://cocodataset.org/#explore
	
## Code Implementation

This application opens a camera preview, collects all the frames and converts them to bitmap. The network is built via Neural Network builder by passing Quant_YoloNas_s_320.dlc as the input. The bitmap is then given to the model for inference, which returns object prediction and localization of the respective object.


### Prerequisite for Camera Preview.

Permission to obtain camera preview frames is granted in the following file:
```python
/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.CAMERA" />
 ```
In order to use camera2 APIs, add the below feature
```python
<uses-feature android:name="android.hardware.camera2" />
```
### Loading Model
Code snippet for neural network connection and loading model:
```java
snpe = snpeBuilder.setOutputLayers({})
            .setPerformanceProfile(zdl::DlSystem::PerformanceProfile_t::BURST)
            .setExecutionPriorityHint(
                    zdl::DlSystem::ExecutionPriorityHint_t::HIGH)
            .setRuntimeProcessorOrder(runtimeList)
            .setUseUserSuppliedBuffers(useUserSuppliedBuffers)
            .setPlatformConfig(platformConfig)
            .setInitCacheMode(useCaching)
            .setCPUFallbackMode(true)
            .setUnconsumedTensorsAsOutputs(true) //To get output from two nodes
            .build();  //builds the network
```
### Preprocessing
The bitmap image is passed as openCV Mat to native and then converted to BGR Mat of size 320x320x3. Basic image processing depends on the kind of input shape required by the model, then writing that processed image into application buffer.
```java
    cv::Mat img320;
    cv::resize(img,img320,cv::Size(320,320),cv::INTER_LINEAR); 

    float inputScale = 0.00392156862745f;    //normalization value, this is 1/255

    float * accumulator = reinterpret_cast<float *> (&dest_buffer[0]);

    //opencv read in BGRA by default
    cvtColor(img320, img320, CV_BGRA2BGR);
    LOGI("num of channels: %d",img320.channels());
    int lim = img320.rows*img320.cols*3;
    for(int idx = 0; idx<lim; idx++)
        accumulator[idx]= img320.data[idx]*inputScale;
 ```
 
 ## PostProcessing
 This included getting the class with highest confidence for each 2100 boxes and applying Non-Max Suppression to remove overlapping boxes.
 
 ```python
 for(int i =0;i<(2100);i++)  
    {
        int start = i*80;
        int end = (i+1)*80;

        auto it = max_element (BBout_class.begin()+start, BBout_class.begin()+end);
        int index = distance(BBout_class.begin()+start, it);

        std::string classname = classnamemapping[index];
        if(*it>=0.5 )
        {
            int x1 = BBout_boxcoords[i * 4 + 0];
            int y1 = BBout_boxcoords[i * 4 + 1];
            int x2 = BBout_boxcoords[i * 4 + 2];
            int y2 = BBout_boxcoords[i * 4 + 3];
            Boxlist.push_back(BoxCornerEncoding(x1, y1, x2, y2,*it,classname));
        }
    }

    std::vector<BoxCornerEncoding> reslist = NonMaxSuppression(Boxlist,0.20);
```
then we just scale the coords for original image

```python
        float top,bottom,left,right;
        left = reslist[k].y1 * ratio_1;   //y1
        right = reslist[k].y2 * ratio_1;  //y2

        bottom = reslist[k].x1 * ratio_2;  //x1
        top = reslist[k].x2 * ratio_2;   //x2
```

## Drawing bounding boxes

```python
 RectangleBox rbox = boxlist.get(j);
            float y = rbox.left;
            float y1 = rbox.right;
            float x =  rbox.top;
            float x1 = rbox.bottom;

            String fps_textLabel = "FPS: "+String.valueOf(rbox.fps);
            canvas.drawText(fps_textLabel,10,70,mTextColor);

            String processingTimeTextLabel= rbox.processing_time+"ms";

            canvas.drawRect(x1, y, x, y1, mBorderColor);
            canvas.drawText(rbox.label,x1+10, y+40, mTextColor);
            canvas.drawText(processingTimeTextLabel,x1+10, y+90, mTextColor);
```
	    
# Build and run with Android Studio

## Build APK file with Android Studio 

1. Clone QIDK repo. 

2. Use the GenerateDLC.ipynb notebook to generate the DLC (Quant_yoloNas_s_320.dlc) and 
   resolve all necessary dependencies.
   
3. Import folder VisionSolution1-ObjectDetection-YoloNas as a project in Android Studio 

4. Compile the project. 

5. Output APK file should get generated : app-debug.apk

6. Prepare the Qualcomm Innovators development kit to install the application

7. If Unsigned or Signed DSP runtime is not getting detected, then please check the logcat logs for the FastRPC error. DSP runtime may not get detected due to SE Linux security policy. Please try out following commands to set permissive SE Linux policy.

It is recommended to run below commands.
```java
adb disable-verity
adb reboot
adb root
adb remount
adb shell setenforce 0
```

8. Install and test application : app-debug.apk
```java
adb install -r -t app-debug.apk
```

9. launch the application

Following is the basic "Object Detection" Android App 

1. On first launch of application, user needs to provide camera permissions
2. Camera will open and pose will be seen, if human is visible on the screen 
3. User can select appropriate run-time for model, and observe performance difference

Same results for the application are : 

## Demo of the application
![Screenshot](.//demo/ObjectDetectYoloNAS.gif)

# References
1. SSD - Single shot Multi box detector - https://arxiv.org/pdf/1512.02325.pdf
2. https://github.com/Deci-AI/super-gradients
3. https://zenodo.org/record/7789328

	
###### *Snapdragon and Qualcomm AI Runtime (QAIRT) are products of Qualcomm Technologies, Inc. and/or its subsidiaries.*
