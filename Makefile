export TARGET := iphone:clang:latest:14.0
export ARCHS = arm64 arm64e
export THEOS_SDK_DIR = $(THEOS)/sdks/iPhoneOS14.5.sdk
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Magnify

Magnify_FILES = Magnify.xm
Magnify_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += magnifyprefs
include $(THEOS_MAKE_PATH)/aggregate.mk
