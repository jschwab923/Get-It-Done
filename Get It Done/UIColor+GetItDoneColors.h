//
//  UIColor+GetItDoneColors.h
//
//  Created by Jeff Schwab
//  Copyright (c) 2014 Jeff Schwab All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GetItDoneColors)

+ (UIColor *)colorFromHexCode:(NSString *)hexString;

+ (UIColor *)darkBlueColor;
+ (UIColor *)blueGrayColor;
+ (UIColor *)darkBlueGrayColor;
+ (UIColor *)lightBluePurpleColor;
+ (UIColor *)blueGreenColor;
+ (UIColor *)darkPurpleColor;
+ (UIColor *)lightDarkGrayColor;

+ (UIColor *)blendedColorWithForegroundColor:(UIColor *)foregroundColor
                              backgroundColor:(UIColor *)backgroundColor
                                 percentBlend:(CGFloat) percentBlend;

@end
