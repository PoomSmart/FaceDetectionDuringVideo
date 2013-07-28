GO_EASY_ON_ME = 1

include theos/makefiles/common.mk
export ARCHS = armv7 armv7s
TWEAK_NAME = FDDVR
FDDVR_FILES = FDDVR.x

include $(THEOS_MAKE_PATH)/tweak.mk
