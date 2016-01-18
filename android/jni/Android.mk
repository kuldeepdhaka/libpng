LOCAL_PATH:= $(call my-dir)

include $(CLEAR_VARS)

REL_PATH:= ../..
ABS_PATH:= $(LOCAL_PATH)/$(REL_PATH)

ARM_NEON_OPT=false
ifeq ($(TARGET_ARCH_ABI),$(filter $(TARGET_ARCH_ABI), armeabi-v7a arm64-v8a))
ARM_NEON_OPT=true
endif

LOCAL_SRC_FILES:= \
	$(REL_PATH)/pngget.c			\
	$(REL_PATH)/pngread.c		\
	$(REL_PATH)/pngrutil.c		\
	$(REL_PATH)/pngtrans.c		\
	$(REL_PATH)/pngwtran.c		\
	$(REL_PATH)/png.c				\
	$(REL_PATH)/pngmem.c			\
	$(REL_PATH)/pngrio.c			\
	$(REL_PATH)/pngset.c			\
	$(REL_PATH)/pngwio.c			\
	$(REL_PATH)/pngerror.c		\
	$(REL_PATH)/pngpread.c		\
	$(REL_PATH)/pngrtran.c		\
	$(REL_PATH)/pngwrite.c		\
	$(REL_PATH)/pngwutil.c		\

ifeq ($(ARM_NEON_OPT),true)
LOCAL_SRC_FILES += \
	$(REL_PATH)/arm/arm_init.c		\
	$(REL_PATH)/arm/filter_neon.S		\
	$(REL_PATH)/arm/filter_neon_intrinsics.c
endif

LOCAL_C_INCLUDES:= \
		$(ABS_PATH)				\
		$(LOCAL_PATH)/../include

LOCAL_EXPORT_C_INCLUDES:=	\
	$(ABS_PATH)	\
	$(LOCAL_PATH)/../include

LOCAL_MODULE:= png
LOCAL_LDLIBS:= -llog -lz

ifeq ($(ARM_NEON_OPT),true)
#cpufeature is only required for ARM (to detect in runtime)
LOCAL_STATIC_LIBRARIES := cpufeatures

# Set flag to let libpng include it
LOCAL_CFLAGS += -DPNG_ARM_NEON_OPT=1
endif

LOCAL_CFLAGS += -DHAVE_CONFIG_H=1
LOCAL_CFLAGS += -D_FORTIFY_SOURCE=2
LOCAL_CFLAGS += -Ofast -funroll-loops -flto

ifeq ($(NDK_DEBUG),"1")
# debug build
LOCAL_CFLAGS += -g -Wall -Wwrite-strings -Wsign-compare
LOCAL_CFLAGS += -Wextra  -Wno-empty-body -Wno-unused-parameter
LOCAL_CFLAGS += -Wformat-security
endif

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/cpufeatures)
