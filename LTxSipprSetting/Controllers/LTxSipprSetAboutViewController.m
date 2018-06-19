//
//  LTxSipprSetAboutViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/28.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprSetAboutViewController.h"
#import "LTxSipprSetAboutHistoryTableViewController.h"

@interface LTxSipprSetAboutViewController ()

@property (nonatomic, strong) UILabel* appNameL;
@property (nonatomic, strong) UILabel* versionL;
@property (nonatomic, strong) UIButton* historyBtn;

@property (nonatomic, strong) UILabel* tipL;

@end

@implementation LTxSipprSetAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LTxLocalizedString(@"text_setting_about");
    
    [self setupComponents];
    [self addConstraintsOnComponents];
}

-(void)setupComponents{
    
     NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    //应用名称
    _appNameL = [[UILabel alloc] init];
    _appNameL.translatesAutoresizingMaskIntoConstraints = NO;
    _appNameL.text = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    _appNameL.textColor = [UIColor darkGrayColor];
    _appNameL.font = [UIFont systemFontOfSize:19];
    [self.view addSubview:_appNameL];
    
    //版本信息
    _versionL = [[UILabel alloc] init];
    _versionL.translatesAutoresizingMaskIntoConstraints = NO;
    NSString* versionText;
    if ([LTxSipprConfig sharedInstance].isDebug) {
        versionText = [NSString stringWithFormat:@"%@：v%@ T",LTxLocalizedString(@"text_setting_about_current_version"),[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }else{
        versionText = [NSString stringWithFormat:@"%@：v%@",LTxLocalizedString(@"text_setting_about_current_version"),[infoDictionary objectForKey:@"CFBundleShortVersionString"]];
    }
    _versionL.text = versionText;
    _versionL.textColor = [UIColor grayColor];
    _versionL.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:_versionL];
    
    //更新历史按钮
    _historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _historyBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_historyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_historyBtn setTitle:[NSString stringWithFormat:@"   %@   ",LTxLocalizedString(@"text_setting_about_history")] forState:UIControlStateNormal];
    [_historyBtn setBackgroundColor:[LTxSipprConfig sharedInstance].skinColor];
    _historyBtn.layer.cornerRadius = 5.f;
    _historyBtn.clipsToBounds = YES;
    [_historyBtn addTarget:self action:@selector(showHistory) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_historyBtn];
    
    
    _tipL = [[UILabel alloc] init];
    _tipL.translatesAutoresizingMaskIntoConstraints = NO;
    _tipL.text = [LTxSipprConfig sharedInstance].aboutTip;
    _tipL.numberOfLines = 0;
    _tipL.font = [UIFont systemFontOfSize:13];
    _tipL.textColor = [UIColor darkGrayColor];
    [self.view addSubview:_tipL];
}

-(void)addConstraintsOnComponents{
    //应用名称约束
    NSLayoutConstraint* nameXConstraint = [NSLayoutConstraint constraintWithItem:_appNameL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* nameYConstraint = [NSLayoutConstraint constraintWithItem:_appNameL attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.f constant:-100];
    
    //版本约束
    NSLayoutConstraint* versionXConstraint = [NSLayoutConstraint constraintWithItem:_versionL attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_appNameL attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* versionTopConstraint = [NSLayoutConstraint constraintWithItem:_versionL attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_appNameL attribute:NSLayoutAttributeBottom multiplier:1.f constant:20];
    
    //更新按钮
    NSLayoutConstraint* btnXConstraint = [NSLayoutConstraint constraintWithItem:_historyBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_appNameL attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* btnTopConstraint = [NSLayoutConstraint constraintWithItem:_historyBtn attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_versionL attribute:NSLayoutAttributeBottom multiplier:1.f constant:20];
    
    //提示 - 版权
    NSLayoutConstraint* tLeading = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:10];
    NSLayoutConstraint* tTrailing = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:-10];
    NSLayoutConstraint* tBottom = [NSLayoutConstraint constraintWithItem:_tipL attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:-20];
    
    //激活约束，等价于单独设置约束.active = YES;
    [NSLayoutConstraint activateConstraints:@[nameXConstraint,nameYConstraint,versionXConstraint,versionTopConstraint,btnXConstraint,btnTopConstraint,tLeading,tTrailing,tBottom]];
}

-(void)showHistory{
    LTxSipprSetAboutHistoryTableViewController* historyVC = [[LTxSipprSetAboutHistoryTableViewController alloc] init];
    [self.navigationController pushViewController:historyVC animated:true];
}

@end
