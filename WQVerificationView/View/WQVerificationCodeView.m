//
//  WQVerificationCodeView.m
//  WQVerificationView
//
//  Created by wangqi on 2019/2/1.
//  Copyright © 2019 wangqi. All rights reserved.
//

#import "WQVerificationCodeView.h"
#import "UIColor+Ext.h"
#import "NSString+Utility.h"

@implementation WQVerificationCodeView{
    NSMutableString* _codeString;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorVerificationCodeBackground];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)]];
        [self generateCode];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self drawCode:rect];
}

- (void)drawCode:(CGRect) rect{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat rectWidth =  rect.size.width;
    CGFloat rectHeight = rect.size.height;
    NSInteger charWidth = rectWidth / 4 - 15;
    NSInteger charHeight = rectHeight - 20;
    
    //draw some random point
    for(NSInteger i=0;i<20;i++){
        CGContextSetRGBFillColor(ctx, arc4random_uniform(255)/255.0, arc4random_uniform(255)/255.0,
                                 arc4random_uniform(255)/255.0,1);
        CGFloat x = arc4random_uniform(rectWidth);
        CGFloat y = arc4random_uniform(rectHeight);
        CGContextFillRect(ctx, CGRectMake(x, y, 1.5, 1.5));
    }
    
    UIBezierPath* path = [UIBezierPath bezierPath];
    
    CGFloat pointX,pointY;
    NSString* num;
    UIFont* numFont;
    CGSize numSize;
    CGFloat rotation;
    //draw 4 random number
    for(int i=0;i<4;i++){
        pointX = arc4random_uniform((unsigned int)charWidth) + i*rectWidth/4.0f;
        pointY = arc4random_uniform((unsigned int)(charHeight));
        
        num = [_codeString substringWithRange:NSMakeRange((NSUInteger) i, 1)];
        numFont = [UIFont systemFontOfSize:18];
        numSize = [num sizeWithFontCompatible:numFont];
        
        //rotate a random angle
        CGContextSaveGState(ctx);
        CGContextTranslateCTM(ctx, pointX + (numSize.width/2), pointY +(numSize.height/2));
        int angle = arc4random_uniform(50);
        rotation = -(angle * M_PI)/ 180.0f;
        CGContextRotateCTM(ctx, rotation);
        
        NSDictionary * attr = @{NSFontAttributeName:numFont,NSStrokeWidthAttributeName:@5};
        //        [num drawAtPoint:CGPointMake(pointX,pointY) withAttributes:attr];
        [num drawAtPoint:CGPointMake(-numSize.width/2,-numSize.height/2) withAttributes:attr];
        
        CGContextRestoreGState(ctx);
        
        if( i == 0){
            [path moveToPoint: CGPointMake(pointX+(numSize.width/2), pointY+((numSize.height/2)))];
        } else {
            [path addLineToPoint:CGPointMake(pointX+(numSize.width/2), pointY+(numSize.height/2))];
        }
    }
    
    //draw a line through numbers
    path.lineWidth = 1;
    UIColor* lineColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0f green:arc4random_uniform(256)/255.0f blue:arc4random_uniform(256)/255.0f alpha:0.7];
    [lineColor setStroke];
    [path stroke];
    
}

- (void) singleTap:(UITapGestureRecognizer *) recognizer{
    [self refreshCode];

    [self.delegate onVerificationCodeClicked];
}

- (NSString *)getVerficationCodeStr{
    return _codeString;
}

- (void)refreshCode {
    [self generateCode];
    [self setNeedsDisplay];
}

- (void)generateCode {
    _codeString = [[NSMutableString alloc] initWithCapacity:4];
    for(int i=0;i<4;i++){
        NSString *num = [NSString stringWithFormat:@"%d",arc4random_uniform(10)];
        _codeString = (NSMutableString *)[_codeString stringByAppendingString:num];
    }
}

@end
