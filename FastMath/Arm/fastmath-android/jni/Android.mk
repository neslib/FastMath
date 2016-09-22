LOCAL_PATH:= $(call my-dir)/../../Arm32
include $(CLEAR_VARS)
 
LOCAL_MODULE     := fastmath-android
LOCAL_SRC_FILES := approx_32.S\
    common_32.S\
    exponential_32.S\
    matrix2_32.S\
    matrix3_32.S\
    matrix4_32.S\
    trig_32.S\
    vector2_32.S\
    vector3_32.S\
    vector4_32.S
 
include $(BUILD_STATIC_LIBRARY)
