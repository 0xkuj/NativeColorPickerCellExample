#import "EXMColorPickerCell.h"

@implementation EXMColorPickerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
  self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

  if (self) {

    self.tintColour = UIColor.systemIndigoColor;

    self.headerLabel = [[UILabel alloc] init];
    self.headerLabel.textColor = self.tintColour;
    self.headerLabel.text = specifier.properties[@"title"];
    self.headerLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
    [self addSubview:self.headerLabel];

    self.headerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [[self.headerLabel centerYAnchor] constraintEqualToAnchor:self.centerYAnchor constant:0].active = true;
    [self.headerLabel.leadingAnchor constraintEqualToAnchor:self.leadingAnchor constant:10].active = YES;
    [self.headerLabel.trailingAnchor constraintEqualToAnchor:self.contentView.trailingAnchor constant:-10].active = YES;

  }

  return self;
}


- (id)target {
  return self;
}


- (id)cellTarget {
  return self;
}


- (SEL)action {
  return @selector(openColorPicker);
}


- (SEL)cellAction {
  return @selector(openColorPicker);
}


- (void)openColorPicker {
  UIViewController *prefsController = [self _viewControllerForAncestor];
  if (@available(iOS 14.0, *)) {
    UIColorPickerViewController *colourPickerVC = [[UIColorPickerViewController alloc] init];
    colourPickerVC.view.tintColor = self.tintColour;
    colourPickerVC.delegate = self;
    NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:YOUR_PREFS];
    if ([dict objectForKey:self.specifier.properties[@"key"]]) {
        colourPickerVC.selectedColor = [self colorWithHexString:[dict objectForKey:self.specifier.properties[@"key"]]];
    } else {
        colourPickerVC.selectedColor = [self colorWithHexString:self.specifier.properties[@"fallback"]];
    }

    colourPickerVC.supportsAlpha = [self.specifier.properties[@"supportAlpha"] boolValue] ?: NO;
    [prefsController presentViewController:colourPickerVC animated:YES completion:nil];
  }
}

- (void)updatePreview {
  self.colorPreview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 29, 29)];
  self.colorPreview.layer.borderWidth = 1.2;
  self.colorPreview.layer.borderColor = self.tintColour.CGColor;
  self.colorPreview.layer.cornerRadius = 14.5;
  NSDictionary* dict = [NSDictionary dictionaryWithContentsOfFile:YOUR_PREFS];
  if ([dict objectForKey:self.specifier.properties[@"key"]]) {
    self.colorPreview.backgroundColor = [self colorWithHexString:[dict objectForKey:self.specifier.properties[@"key"]]];
  } else {
    self.colorPreview.backgroundColor = [self colorWithHexString:self.specifier.properties[@"fallback"]];
  }

  [self setAccessoryView:self.colorPreview];
}

- (void)didMoveToSuperview {
  [super didMoveToSuperview];
  [self updatePreview];
  [self.specifier setTarget:self];
  [self.specifier setButtonAction:@selector(openColorPicker)];
}


- (void)colorPickerViewControllerDidSelectColor:(UIColorPickerViewController *)viewController API_AVAILABLE(ios(14.0)){

    UIColor *selectedColour = viewController.selectedColor;
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:YOUR_PREFS];
    if (!settings) {
        settings = [NSMutableDictionary dictionary];
    }
    [settings setObject:[self hexStringFromColor:selectedColour] forKey:self.specifier.properties[@"key"]];
    [settings writeToFile:YOUR_PREFS atomically:YES];
    [self updatePreview];
}


- (void)colorPickerViewControllerDidFinish:(UIColorPickerViewController *)viewController API_AVAILABLE(ios(14.0)){

    UIColor *selectedColour = viewController.selectedColor;
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:YOUR_PREFS];
    if (!settings) {
        settings = [NSMutableDictionary dictionary];
    }
    [settings setObject:[self hexStringFromColor:selectedColour] forKey:self.specifier.properties[@"key"]];
    [settings writeToFile:YOUR_PREFS atomically:YES];
    [self updatePreview];
}


-(UIColor*)colorWithHexString:(NSString*)hex {

  if ([hex isEqualToString:@"red"]) {
    return UIColor.systemRedColor;
  } else if ([hex isEqualToString:@"orange"]) {
    return UIColor.systemOrangeColor;
  } else if ([hex isEqualToString:@"yellow"]) {
    return UIColor.systemYellowColor;
  } else if ([hex isEqualToString:@"green"]) {
    return UIColor.systemGreenColor;
  } else if ([hex isEqualToString:@"blue"]) {
    return UIColor.systemBlueColor;
  } else if ([hex isEqualToString:@"teal"]) {
    return UIColor.systemTealColor;
  } else if ([hex isEqualToString:@"indigo"]) {
    return UIColor.systemIndigoColor;
  } else if ([hex isEqualToString:@"purple"]) {
    return UIColor.systemPurpleColor;
  } else if ([hex isEqualToString:@"pink"]) {
    return UIColor.systemPinkColor;
  } else if ([hex isEqualToString:@"default"]) {
    return UIColor.labelColor;
  } else if ([hex isEqualToString:@"tertiary"]) {
    return UIColor.tertiaryLabelColor;
  } else {

    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
      cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
      [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
      [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
      [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
      cleanString = [cleanString stringByAppendingString:@"ff"];
    }

    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];

    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
  }
}

- (NSString *)hexStringFromColor:(UIColor *)color {
  const CGFloat *components = CGColorGetComponents(color.CGColor);

  CGFloat r = components[0];
  CGFloat g = components[1];
  CGFloat b = components[2];
  CGFloat a = components[3];

  return [NSString stringWithFormat:@"%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255)];
}
@end