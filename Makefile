TARGET := iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = com.dragon.read
THEOS_PACKAGE_SCHEME = rootless
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = fanqiefn
fanqiefn_FILES = Tweak.xm
fanqiefn_CFLAGS = -fobjc-arc
fanqiefn_FRAMEWORKS = UIKit UserNotifications

include $(THEOS_MAKE_PATH)/tweak.mk
