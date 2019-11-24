ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  LOCAL_PATH:= $(call my-dir)/../../Arm64
else  
  LOCAL_PATH:= $(call my-dir)/../../Arm32
endif

include $(CLEAR_VARS)
 
ifdef FORCE_THUMB
LOCAL_CFLAGS += -DFORCE_THUMB
endif

LOCAL_MODULE    := fastmath-android

ifeq ($(TARGET_ARCH_ABI),arm64-v8a)
  LOCAL_SRC_FILES := approx_64.S\
    common_64.S\
    exponential_64.S\
    matrix2_64.S\
    matrix3_64.S\
    matrix4_64.S\
    trig_64.S\
    vector2_64.S\
    vector3_64.S\
    vector4_64.S
else
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
endif
 
include $(BUILD_STATIC_LIBRARY)
