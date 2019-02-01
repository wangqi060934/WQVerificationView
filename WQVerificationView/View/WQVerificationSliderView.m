//
//  WQVerificationSliderView.m
//  WQVerificationView
//
//  Created by wangqi on 2019/2/1.
//  Copyright © 2019 wangqi. All rights reserved.
//

#import "WQVerificationSliderView.h"
#import "UIColor+Ext.h"
#import "UIImage+Ext.h"

#ifndef PUZZLE_SIZE
#define PUZZLE_SIZE 50
#endif
#ifndef TOLERATION_SIZE
#define TOLERATION_SIZE 5
#endif

#pragma mark - CustomHeightSlider
@interface CustomHeightSlider : UISlider

@end
@implementation CustomHeightSlider

- (CGRect)trackRectForBounds:(CGRect)bounds{
    return CGRectMake(0, 0, bounds.size.width, 45);
}

@end

#pragma mark - WQVerificationSliderView
@interface WQVerificationSliderView()
@property(nonatomic,strong) CustomHeightSlider* slider;
@property(nonatomic,strong) UILabel* tipLabel;
@property(nonatomic,strong) UIImageView* backgroundImage;
@property(nonatomic,assign) CGFloat backgroundScale;
@property(nonatomic,strong) UIImageView* puzzleImage;
@property(nonatomic,assign) unsigned int randomX,randomY;   /* the origin of the puzzle image*/
@end

@implementation WQVerificationSliderView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp{
    //there are 2 point (leading/trailing) need to minus
    self.slider = [[CustomHeightSlider alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width-4, self.bounds.size.height)];
    CGPoint sliderCenter = self.slider.center;
    sliderCenter.x+=2;
    
    self.slider.center = sliderCenter;
    self.slider.minimumValue=0;
    self.slider.maximumValue=1;
    self.slider.value=0;
    self.slider.continuous=YES;
    [self.slider addTarget:self action:@selector(sliderChanged:) forControlEvents:UIControlEventValueChanged];
    [self.slider addTarget:self action:@selector(sliderDown:) forControlEvents:UIControlEventTouchDown];
    [self.slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpInside];
    [self.slider addTarget:self action:@selector(sliderUp:) forControlEvents:UIControlEventTouchUpOutside];
    [self.slider setMinimumTrackImage:[UIImage imageWithColor:[UIColor colorSliderFailed]] forState:UIControlStateNormal];
    [self.slider setMaximumTrackImage:[UIImage imageWithColor:[UIColor colorSlideBackground]] forState:UIControlStateNormal];
    [self.slider setThumbImage:[self customThumbImageForState:VALIDATE_STATE_DEFAULT] forState:UIControlStateNormal];
    [self addSubview:self.slider];

    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [self.tipLabel setText:@"向右拖动滑块填充拼图"];
    [self.tipLabel setTextColor:[UIColor colorWithHexString:@"C7C7CD" alpha:1]];
    [self.tipLabel setFont:[UIFont systemFontOfSize:16]];

//    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.equalTo(self);
//        make.leading.equalTo(self).offset(2);
//        make.trailing.equalTo(self).offset(-2);
//    }];

    self.backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"city.jpg"]];
    self.backgroundImage.hidden = YES;
    [self addSubview:self.backgroundImage];

    self.backgroundScale = self.backgroundImage.bounds.size.width/self.bounds.size.width;

    //make the UILabel to shimmer
    CAGradientLayer* gradientLayer = [CAGradientLayer layer];
    gradientLayer.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    CGSize labelSize = self.tipLabel.intrinsicContentSize;
    gradientLayer.bounds = CGRectMake(0, 0, labelSize.width, labelSize.height);

    gradientLayer.startPoint = CGPointMake(0, 0.5);
    gradientLayer.endPoint = CGPointMake(1, 0.5);
    UIColor* labelColor = [UIColor colorWithHexString:@"C7C7CD" alpha:1];
    gradientLayer.colors = @[
            (__bridge id)[labelColor CGColor],
            (__bridge id)[[UIColor colorSliderDefault] CGColor],
            (__bridge id)[labelColor CGColor]
    ];
    gradientLayer.locations=@[@0.25,@0.5,@0.75];

    CABasicAnimation* gradientAnim = [CABasicAnimation animationWithKeyPath:@"locations"];
    gradientAnim.fromValue = @[@0, @0, @0.25];
    gradientAnim.toValue = @[@0.75, @1, @1];
    gradientAnim.duration = 2.5;
    gradientAnim.repeatCount = HUGE;
    gradientAnim.removedOnCompletion = NO;
    [gradientLayer addAnimation:gradientAnim forKey:nil];

    [self.layer addSublayer:gradientLayer];
    gradientLayer.mask = self.tipLabel.layer;
    self.tipLabel.frame = gradientLayer.bounds;
    
}

- (void)layoutSubviews{
    [super layoutSubviews];

    
}

/**
 * generate the thumb image for specific state
 */
-(UIImage*) customThumbImageForState:(VALIDATE_STATE) state{
    CGSize size = CGSizeMake(45, 45);
    UIGraphicsBeginImageContext(size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    if(state == VALIDATE_STATE_SUCCESS){
        //green
        CGContextSetFillColorWithColor(ctx, [[UIColor colorSliderSuccess] CGColor]);
        CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));

        CGContextSetLineWidth(ctx, 2);
        CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextMoveToPoint(ctx, size.width/3-2, size.height*0.5);
        CGContextAddLineToPoint(ctx, size.width*0.5-2, size.height*2/3);
        CGContextAddLineToPoint(ctx, size.width*5/6-2, size.height/3);
        CGContextStrokePath(ctx);
    } else if(state == VALIDATE_STATE_FAILED){
       //red
        CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
        CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));

        CGContextSetLineWidth(ctx, 2);
        CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextMoveToPoint(ctx, size.width*0.25, size.height*0.25);
        CGContextAddLineToPoint(ctx, size.width*0.75, size.height*0.75);
        CGContextMoveToPoint(ctx, size.width*0.25, size.height*0.75);
        CGContextAddLineToPoint(ctx, size.width*0.75, size.height*0.25);
        CGContextStrokePath(ctx);
    } else {
        //blue
        CGContextSetFillColorWithColor(ctx, [[UIColor colorSliderDefault] CGColor]);
        CGContextFillRect(ctx, CGRectMake(0, 0, size.width, size.height));

        CGContextSetLineWidth(ctx, 2);
        CGContextSetStrokeColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextMoveToPoint(ctx, size.width*5/8, size.height*0.5);
        CGContextAddLineToPoint(ctx, size.width*3/8, size.height*0.25);
        CGContextMoveToPoint(ctx, size.width*5/8, size.height*0.5);
        CGContextAddLineToPoint(ctx, size.width*3/8, size.height*0.75);
        CGContextStrokePath(ctx);
    }

    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (void)sliderUp:(UISlider*) sender{
    [self.slider setEnabled:NO];
    BOOL isSuccess = fabs(sender.value*(self.backgroundImage.bounds.size.width-PUZZLE_SIZE) - self.randomX) < TOLERATION_SIZE;
    if(isSuccess){
        [self slideSuccess];
        self.validateState = VALIDATE_STATE_SUCCESS;
    } else {
        [self slideFailed];
        self.validateState = VALIDATE_STATE_FAILED;
    }

    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundImage.alpha=0;
    } completion:^(BOOL finished){
        if(finished){
            self.backgroundImage.hidden = YES;
            self.backgroundImage.alpha=1;
        }
    }];
}

- (void)slideFailed{
    [self.slider setThumbImage:[self customThumbImageForState:VALIDATE_STATE_FAILED] forState:UIControlStateNormal];
    [self.slider setMinimumTrackImage:[UIImage imageWithColor:[[UIColor redColor]colorWithAlphaComponent:0.2]] forState:UIControlStateNormal];

    [UIView animateWithDuration:0.5 delay:0.3 options:UIViewAnimationOptionCurveEaseIn animations:^{
        [self.slider setValue:0 animated:YES];
    } completion:^(BOOL finished){
        self.tipLabel.hidden=NO;

        [self.slider setMinimumTrackImage:[UIImage imageWithColor:[UIColor colorSliderFailed]] forState:UIControlStateNormal];
        [self.slider setThumbImage:[self customThumbImageForState:VALIDATE_STATE_DEFAULT] forState:UIControlStateNormal];

        [self.slider setEnabled:YES];
    }];
}

- (void)slideSuccess{
    [self.slider setThumbImage:[self customThumbImageForState:VALIDATE_STATE_SUCCESS] forState:UIControlStateNormal];
    //light green
    [self.slider setMinimumTrackImage:[UIImage imageWithColor:[UIColor colorWithHexString:@"74D572" alpha:0.2]] forState:UIControlStateNormal];

    [self.slider setEnabled:NO];
    self.tipLabel.hidden=YES;
}

- (void)sliderChanged:(UISlider*) sender{
    if(sender.value>0.1){
        self.tipLabel.hidden=YES;
    } else {
        self.tipLabel.hidden=NO;
    }

    self.puzzleImage.frame = CGRectMake((self.backgroundImage.bounds.size.width-PUZZLE_SIZE)*sender.value, self.randomY, PUZZLE_SIZE, PUZZLE_SIZE);
}

- (void)sliderDown:(UISlider*) sender{
    [self initPuzzleAndBackground];
}

- (void)initPuzzleAndBackground{
    [self.backgroundImage setImage:[UIImage imageNamed:@"city.jpg"]];
    self.backgroundImage.hidden = NO;
    float backHeight = self.bounds.size.width*2/3;
    self.backgroundImage.frame = CGRectMake(0, -backHeight , self.bounds.size.width, backHeight);

    self.randomX = arc4random_uniform(self.backgroundImage.bounds.size.width-2*PUZZLE_SIZE) + PUZZLE_SIZE;
    self.randomY = arc4random_uniform(self.backgroundImage.bounds.size.height-2*PUZZLE_SIZE) + PUZZLE_SIZE;
    CGRect rect = CGRectMake(self.randomX, self.randomY, PUZZLE_SIZE, PUZZLE_SIZE);

    if(self.puzzleImage.superview){
        [self.puzzleImage removeFromSuperview];
    }
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.backgroundImage.image CGImage],
            CGRectMake(self.randomX*self.backgroundScale, self.randomY*self.backgroundScale, PUZZLE_SIZE*self.backgroundScale, PUZZLE_SIZE*self.backgroundScale));

    UIImage* cropImage = [UIImage imageWithCGImage:imageRef scale:self.backgroundImage.image.scale orientation:self.backgroundImage.image.imageOrientation];
    if(!self.puzzleImage){
        self.puzzleImage = [[UIImageView alloc]initWithImage:cropImage];
    } else {
        [self.puzzleImage setImage:cropImage];
    }
    CGImageRelease(imageRef);
    [self.puzzleImage.layer setBorderColor:[[UIColor whiteColor]CGColor]];
    [self.puzzleImage.layer setBorderWidth:1];
    [self.backgroundImage addSubview:self.puzzleImage];
    self.puzzleImage.frame = CGRectMake(0, self.randomY, PUZZLE_SIZE, PUZZLE_SIZE);

    UIGraphicsBeginImageContext(self.backgroundImage.bounds.size);
    [self.backgroundImage drawRect:self.backgroundImage.bounds];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor]CGColor]);
    CGContextFillRect(ctx, rect);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.backgroundImage setImage:newImage];
}

@end
