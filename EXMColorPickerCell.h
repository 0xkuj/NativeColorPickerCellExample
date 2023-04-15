#import <Preferences/Preferences.h>

#define YOUR_PREFS @"/var/mobile/Library/Preferences/com.0xkuj.nativecolorpicker.plist"

@interface PSTableCell (PrivateColourPicker)
- (UIViewController *)_viewControllerForAncestor;
@end

@interface EXMColorPickerCell : PSTableCell <UIColorPickerViewControllerDelegate>
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UIView *colorPreview;
@property (nonatomic, retain) UIColor *tintColour;
@end