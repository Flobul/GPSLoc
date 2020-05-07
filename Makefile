ARCHS = armv7 armv7s arm64

include $(THEOS)/makefiles/common.mk

TOOL_NAME = gpsloc
gpsloc_FILES = main.mm
gpsloc_FRAMEWORKS = CoreLocation
gpsloc_CODESIGN_FLAGS = -Sentitlements.xml

include $(THEOS_MAKE_PATH)/tool.mk

