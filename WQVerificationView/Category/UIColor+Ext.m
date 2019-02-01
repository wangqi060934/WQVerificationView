//
// Created by wangqi on 2019-02-01.
// Copyright (c) 2019 wangqi. All rights reserved.
//

#import "UIColor+Ext.h"


@implementation UIColor (Ext)
/**
 * @return a color I don't know how to describe
 */
+ (UIColor *)colorVerificationCodeBackground {
    return [self colorWithHexString:@"998899" alpha:1];
}

/**
 * @return a light gray color
 */
+ (UIColor *)colorSlideBackground{
    return [self colorWithHexString:@"F5F5F5" alpha:1];
}

/**
 * @return a red color
 */
+ (UIColor *)colorSliderFailed{
    return [self colorWithHexString:@"A2E3F6" alpha:1];
}

/**
 * @return a blue color
 */
+ (UIColor *)colorSliderDefault{
    return [self colorWithHexString:@"37AEFF" alpha:1];
}

/**
 * @return a green color
 */
+ (UIColor *)colorSliderSuccess{
    return [self colorWithHexString:@"74D572" alpha:1];
}

/**
 *  @param hexString #ffffff
 *  @param alpha     透明度
 */
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha {
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];

    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    //如果是0x开头，则去掉0x
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString stringByReplacingOccurrencesOfString:@"0X" withString:@""];
    }
    //如果非十六进制，返回白色
    if ([cString length] != 6) {
        return [UIColor whiteColor];
    }

    //分别取RGB的值
    NSRange range = NSMakeRange(0, 2);
    NSString *rString = [cString substringWithRange:range];

    range.location = 2;
    NSString *gString = [cString substringWithRange:range];

    range.location = 4;
    NSString *bString = [cString substringWithRange:range];

    unsigned int r, g, b;
    //NSScanner把扫描出的十六进制的字符串转换成Int类型
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    //转换为UIColor
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:alpha];
}

@end