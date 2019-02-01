//
//  ViewController.m
//  WQVerificationView
//
//  Created by wangqi on 2019/2/1.
//  Copyright © 2019 wangqi. All rights reserved.
//

#import "ViewController.h"
#import "WQVerificationSliderView.h"

@interface ViewController ()
@property(nonatomic, strong) WQVerificationCodeView *codeView;
@property(nonatomic, strong) UILabel *codeLabel;
@property(nonatomic, strong) WQVerificationSliderView *sliderView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    [self initRandomCodeViews];

}

- (void)initRandomCodeViews {
    self.codeView = [[WQVerificationCodeView alloc] initWithFrame:CGRectMake(50, 100, 80, 40)];
    self.codeView.delegate = self;
    [self.view addSubview:self.codeView];

    self.codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(180, 100, 80, 40)];
    [self.codeLabel setText:[self.codeView getVerficationCodeStr]];
    [self.view addSubview:self.codeLabel];

    self.sliderView = [[WQVerificationSliderView alloc]
            initWithFrame:CGRectMake(0, 450, [UIScreen mainScreen].bounds.size.width, 45)];
    [self.view addSubview:self.sliderView];
}

- (void)onVerificationCodeClicked {
    [self.codeLabel setText:[self.codeView getVerficationCodeStr]];
}

@end
