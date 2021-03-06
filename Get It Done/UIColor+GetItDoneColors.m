//
//  UIColor+GetItDoneColors.m
//
//  Created by Jeff Schwab
//  Copyright (c) 2014 Jeff Schwab. All rights reserved.
//

#import "UIColor+GetItDoneColors.h"

@implementation UIColor (GetItDoneColors)

// Thanks to http://stackoverflow.com/questions/3805177/how-to-convert-hex-rgb-color-codes-to-uicolor
+ (UIColor *) colorFromHexCode:(NSString *)hexString {
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
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


+ (UIColor *)darkBlueColor
{
    return [UIColor colorWithRed:0.134 green:0.326 blue:0.483 alpha:1.000];
}

+ (UIColor *)blueGrayColor
{
    return [UIColor colorWithRed:0.145 green:0.160 blue:0.198 alpha:1.000];
}

+ (UIColor *)darkBlueGrayColor
{
    return [UIColor colorWithRed:0.077 green:0.092 blue:0.119 alpha:1.000];
}

+ (UIColor *)lightBluePurpleColor
{
    return [UIColor colorWithRed:0.64 green:0.67 blue:0.83 alpha:1.000];
}

+ (UIColor *)blueGreenColor
{
    return [UIColor colorWithRed:0.498 green:0.6 blue:0.596 alpha:1.000];
}

+ (UIColor *)darkPurpleColor
{
    return [UIColor colorWithRed:0.245 green:0.219 blue:0.292 alpha:1.000];
}

+ (UIColor *)lightDarkGrayColor
{
    return [UIColor colorWithRed:0.250 green:0.263 blue:0.296 alpha:1.000];
}


+ (UIColor *) blendedColorWithForegroundColor:(UIColor *)foregroundColor
                              backgroundColor:(UIColor *)backgroundColor
                                 percentBlend:(CGFloat) percentBlend {
    CGFloat onRed, offRed, newRed, onGreen, offGreen, newGreen, onBlue, offBlue, newBlue, onWhite, offWhite;
    if ([foregroundColor getWhite:&onWhite alpha:nil]) {
        onRed = onWhite;
        onBlue = onWhite;
        onGreen = onWhite;
    }
    else {
        [foregroundColor getRed:&onRed green:&onGreen blue:&onBlue alpha:nil];
    }
    if ([backgroundColor getWhite:&offWhite alpha:nil]) {
        offRed = offWhite;
        offBlue = offWhite;
        offGreen = offWhite;
    }
    else {
        [backgroundColor getRed:&offRed green:&offGreen blue:&offBlue alpha:nil];
    }
    newRed = onRed * percentBlend + offRed * (1-percentBlend);
    newGreen = onGreen * percentBlend + offGreen * (1-percentBlend);
    newBlue = onBlue * percentBlend + offBlue * (1-percentBlend);
    return [UIColor colorWithRed:newRed green:newGreen blue:newBlue alpha:1.0];
}

@end
