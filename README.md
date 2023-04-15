# NativeColorPickerCellExample
You can use this repository to understand how to create your own color picker cell insie your preferences.
This was created to help others avoid including libcolorpicker or others which are not updated to rootless jailbreaks yet.

# Instructions

1. Inside your preference project, download and include these two files:
    * EXMColorPickerCell.h
    * EXMColorPickerCell.m
    
2. Change the path inside EXMColorPickerCell.h to your preference file path

3. Inside your .plist file where you add the cells into your viewcontroller (in this example, Root.plist) add the color picker cell, for example:
```xml
<dict>
  <key>cell</key>
  <string>PSLinkCell</string>
  <key>cellClass</key>
  <string>EXMColorPickerCell</string>
  <key>fallback</key>
  <string>FFFFFF</string>
  <key>key</key>
  <string>YOURKEY</string>
  <key>supportAlpha</key>
  <false/>
  <key>defaults</key>
  <string>com.0xkuj.nativecolorpicker</string>
  <key>PostNotification</key>
  <string>com.0xkuj.nativecolorpicker.settingschanged</string>
  <key>label</key>
  <string>Example Color Picker</string>
</dict>
```

That's it! You implemented a native color picker cell without using any dependency.

# Read the value from your main project
Every color you pick, is saved with a HEX value in your preference plist. in order to parse that, you may want to create a static method to read this value and get this color. an example can be found in this project:
```objc
+ (UIColor *)colorWithHexString:(NSString*)hex {

    NSString *reductedString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if ([reductedString length] == 3) {
      reductedString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
      [reductedString substringWithRange:NSMakeRange(0, 1)],[reductedString substringWithRange:NSMakeRange(0, 1)],
      [reductedString substringWithRange:NSMakeRange(1, 1)],[reductedString substringWithRange:NSMakeRange(1, 1)],
      [reductedString substringWithRange:NSMakeRange(2, 1)],[reductedString substringWithRange:NSMakeRange(2, 1)]];
    }

    if ([reductedString length] == 6) {
      reductedString = [reductedString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:reductedString] scanHexInt:&baseValue];
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
```
Just call this method with the HEX value you read from your pref, and you will get the color that was picked.
Enjoy!
