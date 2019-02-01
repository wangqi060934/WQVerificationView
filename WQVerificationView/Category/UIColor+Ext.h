//
// Created by wangqi on 2019-02-01.
// Copyright (c) 2019 wangqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Ext)
+ (UIColor *)colorVerificationCodeBackground;
+ (UIColor *)colorWithHexString:(NSString *)hexString alpha:(CGFloat)alpha;
+ (UIColor *)colorSliderFailed;
+ (UIColor *)colorSliderDefault;
+ (UIColor *)colorSliderSuccess;
+ (UIColor *)colorSlideBackground;
@end