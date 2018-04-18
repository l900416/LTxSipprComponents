//
//  LTxSipprSetInstallQrcodeViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprSetInstallQrcodeViewController.h"
#import "LTxSipprCameraQrcodeEncode.h"

@interface LTxSipprSetInstallQrcodeViewController ()

@property (nonatomic, strong) UIImageView* qrcodeImageView;
@property (nonatomic, strong) UILabel* installTipL;

@end

@implementation LTxSipprSetInstallQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = LTxLocalizedString(@"text_setting_qrcode_install");
    
    [self setupComponents];
    [self addConstraintsOnComponents];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [LTxSipprCameraQrcodeEncode fillQRImageWithImageView:_qrcodeImageView qrString:[LTxSipprConfig sharedInstance].instalUrl];
    
    //修改行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[LTxSipprConfig sharedInstance].instalTip];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [[LTxSipprConfig sharedInstance].instalTip length])];
    _installTipL.attributedText = attributedString;
}

-(void)setupComponents{
    //二维码
    _qrcodeImageView = [[UIImageView alloc] init];
    _qrcodeImageView.translatesAutoresizingMaskIntoConstraints = NO;
    _qrcodeImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:_qrcodeImageView];
    
    //提示信息
    _installTipL = [[UILabel alloc] init];
    _installTipL.translatesAutoresizingMaskIntoConstraints = NO;
    _installTipL.font = [UIFont systemFontOfSize:14];
    _installTipL.textColor = [LTxSipprConfig sharedInstance].hintColor;
    _installTipL.numberOfLines = 0;
    [self.view addSubview:_installTipL];
}

-(void)addConstraintsOnComponents{
    //二维码约束
    NSLayoutConstraint* qrImageXConstraint = [NSLayoutConstraint constraintWithItem:_qrcodeImageView attribute:NSLayoutAttributeCenterXWithinMargins relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterXWithinMargins multiplier:1.f constant:0];
    NSLayoutConstraint* qrImageTopConstraint = [NSLayoutConstraint constraintWithItem:_qrcodeImageView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:60];
    NSLayoutConstraint* qrImageWidthConstraint = [NSLayoutConstraint constraintWithItem:_qrcodeImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:200];
    NSLayoutConstraint* qrImageHeightConstraint = [NSLayoutConstraint constraintWithItem:_qrcodeImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_qrcodeImageView attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];
    //提示信息
    NSLayoutConstraint* tipLeadingConstraint = [NSLayoutConstraint constraintWithItem:_installTipL attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:10];
    NSLayoutConstraint* tipLTrailingConstraint = [NSLayoutConstraint constraintWithItem:_installTipL attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-10];
    NSLayoutConstraint* tipLTopConstraint = [NSLayoutConstraint constraintWithItem:_installTipL attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:_qrcodeImageView attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:40];
    
    //激活约束，等价于单独设置约束.active = YES;
    [NSLayoutConstraint activateConstraints:@[qrImageXConstraint,qrImageTopConstraint,qrImageWidthConstraint,qrImageHeightConstraint,tipLeadingConstraint,tipLTrailingConstraint,tipLTopConstraint]];
}

@end
