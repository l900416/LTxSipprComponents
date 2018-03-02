//
//  LTxSipprCameraQrcodeScanView.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprCameraQrcodeScanView.h"
#import "LTxSipprCameraUtil.h"
#import <AVFoundation/AVFoundation.h>

#define LTXSIPPR_CAMERA_QRCODE_ANIMATE_VIEW_HEIGHT 10

@interface LTxSipprCameraQrcodeScanView()

@property (nonatomic, strong) UIView* scanContentView;

@property (nonatomic, strong) UIView* topView;
@property (nonatomic, strong) UIView* rightView;
@property (nonatomic, strong) UIView* bottomView;
@property (nonatomic, strong) UIView* leftView;

@property (nonatomic, strong) UIButton* openFlashLightBtn;
@property (nonatomic, strong) UILabel* tipL;
@property (nonatomic, assign) BOOL openState;//用户打开灯光

/** 扫描动画线(冲击波) */
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, strong) NSLayoutConstraint* animateBottomConstraint;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger animateFlag;

@end

@implementation LTxSipprCameraQrcodeScanView

-(instancetype)init{
    self = [super init];
    if (self) {
        [self setupComponents];
    }
    return self;
}
/*设置界面的组件*/
-(void)setupComponents{
    //扫描边框 ： 固定大小，居中显示
    [self addConstraintsOnComponents];
    _animateFlag = 0;
}


-(void)dealloc{
    [self removeTimer];
    [self.animationImageView removeFromSuperview];
    self.animationImageView = nil;
}


#pragma mark - Timer

-(void)addTimer{
    // 添加定时器
    self.timer =[NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(animationLineAction) userInfo:nil repeats:YES];
}
-(void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}


- (void)animationLineAction {
    ++_animateFlag;
    NSInteger constant = _animateFlag * 3;
    if (constant > LTXSIPPR_CAMERA_QRCODE_SCAN_VIEW_WIDTH) {
        _animateFlag = 0;
        constant = LTXSIPPR_CAMERA_QRCODE_ANIMATE_VIEW_HEIGHT / 2;
    }else if (constant < LTXSIPPR_CAMERA_QRCODE_ANIMATE_VIEW_HEIGHT / 2){
        constant = LTXSIPPR_CAMERA_QRCODE_ANIMATE_VIEW_HEIGHT / 2;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        _animateBottomConstraint.constant = constant;
        [self layoutIfNeeded];
    });
}

-(void)brightnessLight:(BOOL)isNight{
    
    if (isNight) {
        if (_openState) {
            [_openFlashLightBtn setTitle:@" 轻点关闭 " forState:UIControlStateNormal];
        }else{
            [_openFlashLightBtn setTitle:@" 轻点照亮 " forState:UIControlStateNormal];
        }
        _openFlashLightBtn.hidden = NO;
    }else{
        if (_openState) {
            [_openFlashLightBtn setTitle:@" 轻点关闭 " forState:UIControlStateNormal];
            _openFlashLightBtn.hidden = NO;
        }else{
            _openFlashLightBtn.hidden = YES;
        }
    }
    [_openFlashLightBtn setNeedsDisplay];
}

/*控制灯光*/
-(void)openFlashLight:(BOOL)open{
    if (open) {
        [LTxSipprCameraUtil openFlashlight];
    }else{
        [LTxSipprCameraUtil closeFlashlight];
    }
    _openState = open;
}

-(void)openFlashLightAction:(UIButton*)btn{
    if (_openState) {
        [self openFlashLight:NO];
    }else{
        [self openFlashLight:YES];
    }
    
}

#pragma mark - Components
-(void)addConstraintsOnComponents{
    
    //中心扫描区域
    NSLayoutConstraint* scanXConstraint = [NSLayoutConstraint constraintWithItem:self.scanContentView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* scanYConstraint = [NSLayoutConstraint constraintWithItem:self.scanContentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0];
    NSLayoutConstraint* scanWidthConstraint = [NSLayoutConstraint constraintWithItem:self.scanContentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:LTXSIPPR_CAMERA_QRCODE_SCAN_VIEW_WIDTH];
    NSLayoutConstraint* scanHeightConstraint = [NSLayoutConstraint constraintWithItem:self.scanContentView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeWidth multiplier:1.f constant:0];

    //top
    NSLayoutConstraint* topLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-10];
    NSLayoutConstraint* topTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:10];
    NSLayoutConstraint* topTopConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:0];
    NSLayoutConstraint* topBottomConstraint = [NSLayoutConstraint constraintWithItem:self.topView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    
    //bottom
    NSLayoutConstraint* bottomLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-10];
    NSLayoutConstraint* bottomTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:10];
    NSLayoutConstraint* bottomTopConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    NSLayoutConstraint* bottomBottomConstraint = [NSLayoutConstraint constraintWithItem:self.bottomView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:0];
    
    //left
    NSLayoutConstraint* leftLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-10];
    NSLayoutConstraint* leftTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeLeft multiplier:1.f constant:0];
    NSLayoutConstraint* leftTopConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    NSLayoutConstraint* leftBottomConstraint = [NSLayoutConstraint constraintWithItem:self.leftView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    
    //right
    NSLayoutConstraint* rightLeadingConstraint = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeRight multiplier:1.f constant:0];
    NSLayoutConstraint* rightTrailingConstraint = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.f constant:10];
    NSLayoutConstraint* rightTopConstraint = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topView attribute:NSLayoutAttributeBottom multiplier:1.f constant:0];
    NSLayoutConstraint* rightBottomConstraint = [NSLayoutConstraint constraintWithItem:self.rightView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.bottomView attribute:NSLayoutAttributeTop multiplier:1.f constant:0];
    
    //animateImageView
    NSLayoutConstraint* animateLeftConstraint = [NSLayoutConstraint constraintWithItem:self.animationImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.leftView attribute:NSLayoutAttributeRight multiplier:1.f constant:0];
    NSLayoutConstraint* animateRightConstraint = [NSLayoutConstraint constraintWithItem:self.animationImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.rightView attribute:NSLayoutAttributeLeft multiplier:1.f constant:0];
    NSLayoutConstraint* animateHeightConstraint = [NSLayoutConstraint constraintWithItem:self.animationImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:LTXSIPPR_CAMERA_QRCODE_ANIMATE_VIEW_HEIGHT];
    _animateBottomConstraint = [NSLayoutConstraint constraintWithItem:self.animationImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeTop multiplier:1.f constant:LTXSIPPR_CAMERA_QRCODE_ANIMATE_VIEW_HEIGHT / 2];
    
    //OpenFlashLightBtn
    NSLayoutConstraint* openBtnXConstraint = [NSLayoutConstraint constraintWithItem:self.openFlashLightBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* openBtnBottomConstraint = [NSLayoutConstraint constraintWithItem:self.openFlashLightBtn attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-25];
    
    //TipLabel
    NSLayoutConstraint* tipXConstraint = [NSLayoutConstraint constraintWithItem:self.tipL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* tipTopConstraint = [NSLayoutConstraint constraintWithItem:self.tipL attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.scanContentView attribute:NSLayoutAttributeBottom multiplier:1.f constant:30];
    
    [NSLayoutConstraint activateConstraints: @[scanXConstraint,scanYConstraint,scanWidthConstraint,scanHeightConstraint,
                                               topLeadingConstraint,topTrailingConstraint,topTopConstraint,topBottomConstraint,
                                               bottomLeadingConstraint,bottomTrailingConstraint,bottomTopConstraint,bottomBottomConstraint,
                                               leftLeadingConstraint,leftTrailingConstraint,leftTopConstraint,leftBottomConstraint,
                                               rightLeadingConstraint,rightTrailingConstraint,rightTopConstraint,rightBottomConstraint,
                                               animateLeftConstraint,animateRightConstraint,animateHeightConstraint,_animateBottomConstraint,
                                               openBtnXConstraint,openBtnBottomConstraint,
                                               tipXConstraint,tipTopConstraint
                                               ]];
}


#pragma mark - Getter 方法
-(UIView*)scanContentView{
    if (!_scanContentView) {
        _scanContentView = [[UIView alloc] init];
        _scanContentView.translatesAutoresizingMaskIntoConstraints = NO;
        _scanContentView.layer.borderColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6].CGColor;
        _scanContentView.layer.borderWidth = 0.7;
        _scanContentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scanContentView];
    }
    return _scanContentView;
}
-(UIView*)leftView{
    if (!_leftView) {
        _leftView = [[UIView alloc] init];
        _leftView.translatesAutoresizingMaskIntoConstraints = NO;
        _leftView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_leftView];
    }
    return _leftView;
}
-(UIView*)rightView{
    if (!_rightView) {
        _rightView = [[UIView alloc] init];
        _rightView.translatesAutoresizingMaskIntoConstraints = NO;
        _rightView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_rightView];
    }
    return _rightView;
}
-(UIView*)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.translatesAutoresizingMaskIntoConstraints = NO;
        _topView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_topView];
    }
    return _topView;
}
-(UIView*)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
        _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_bottomView];
    }
    return _bottomView;
}

-(UIImageView*)animationImageView{
    if (!_animationImageView) {
        _animationImageView = [[UIImageView alloc] init];
        _animationImageView.translatesAutoresizingMaskIntoConstraints = NO;
        UIImage* image = [UIImage imageWithContentsOfFile: [[NSBundle bundleForClass:self.class] pathForResource:@"LTxSipprComponents.bundle/Images/ic_camera_qrcode_scan_animate_line" ofType:@"png"]];
        _animationImageView.image = image;
        [self addSubview:_animationImageView];
    }
    return _animationImageView;
}

-(UIButton*)openFlashLightBtn{
    if (!_openFlashLightBtn) {
        _openFlashLightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _openFlashLightBtn.translatesAutoresizingMaskIntoConstraints = NO;
        [_openFlashLightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_openFlashLightBtn setBackgroundColor:[UIColor clearColor]];
        [_openFlashLightBtn.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
        [_openFlashLightBtn addTarget:self action:@selector(openFlashLightAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_openFlashLightBtn];
    }
    return _openFlashLightBtn;
}

-(UILabel*)tipL{
    if (!_tipL) {
        _tipL = [[UILabel alloc] init];
        _tipL.translatesAutoresizingMaskIntoConstraints = NO;
        _tipL.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
        _tipL.font = [UIFont systemFontOfSize:16];
        _tipL.textAlignment = NSTextAlignmentCenter;
        _tipL.text = @"放入框内，自动扫描";
        [self addSubview:_tipL];
    }
    return _tipL;
}

@end
