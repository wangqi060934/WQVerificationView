//
//  WQVerificationSliderView.h
//  WQVerificationView
//
//  Created by wangqi on 2019/2/1.
//  Copyright © 2019 wangqi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum {
    VALIDATE_STATE_DEFAULT,
    VALIDATE_STATE_SUCCESS,
    VALIDATE_STATE_FAILED
}VALIDATE_STATE;

/**
 *
 */
@interface WQVerificationSliderView : UIControl
@property(nonatomic,assign) VALIDATE_STATE validateState;
@end

NS_ASSUME_NONNULL_END
