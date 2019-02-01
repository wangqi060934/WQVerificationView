//
//  WQVerificationCodeView.h
//  WQVerificationView
//
//  Created by wangqi on 2019/2/1.
//  Copyright © 2019 wangqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WQVerificationCodeViewDelegate
- (void)onVerificationCodeClicked;
@end

/**
 * display random 4 numbers,click it will refresh the numbers
 */
@interface WQVerificationCodeView : UIView

@property(nonatomic, weak) id <WQVerificationCodeViewDelegate> delegate;

- (NSString *)getVerficationCodeStr;
- (void)refreshCode;
@end

NS_ASSUME_NONNULL_END
