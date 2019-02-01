//
//  NSString+Utility.m
//  WQVerificationView
//
//  Created by wangqi on 2019/2/1.
//  Copyright © 2019 wangqi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSString+Utility.h"

@implementation NSString (Utility)
- (CGSize)sizeWithFontCompatible:(UIFont *)font {
    if([self respondsToSelector:@selector(sizeWithAttributes:)] == YES && font)
    {
        NSDictionary *dictionaryAttributes = @{NSFontAttributeName:font};
        CGSize stringSize = [self sizeWithAttributes:dictionaryAttributes];
        return CGSizeMake(ceil(stringSize.width), ceil(stringSize.height));
    }
    else
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [self sizeWithFont:font];
#pragma clang diagnostic pop
    }
}


@end
