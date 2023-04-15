include $(THEOS)/makefiles/common.mk
ARCHS = arm64 arm64e
BUNDLE_NAME = NativeColorPicker

NativeColorPicker_FILES = EXMRootListController.m EXMColorPickerCell.m
NativeColorPicker_FRAMEWORKS = UIKit
NativeColorPicker_PRIVATE_FRAMEWORKS = Preferences
NativeColorPicker_INSTALL_PATH = /Library/PreferenceBundles
NativeColorPicker_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk
