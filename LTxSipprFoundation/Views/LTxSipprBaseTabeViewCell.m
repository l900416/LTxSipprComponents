//
//  LTxSipprBaseTabeViewCell.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/1/19.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprBaseTabeViewCell.h"
#import "LTxSipprConfig.h"

@interface LTxSipprBaseTabeViewCell()
@property (weak, nonatomic) UIView *bgView;
@end
@implementation LTxSipprBaseTabeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self setupCommonConfig];
}

-(void)setupCommonConfig{
    self.contentView.backgroundColor = [LTxSipprConfig sharedInstance].cellContentViewColor;
    
    self.bgView.layer.cornerRadius = 2.f;
    self.bgView.layer.shadowColor = [LTxSipprConfig sharedInstance].cellContentViewShadowColor;
    self.bgView.layer.shadowOpacity = 0.6;
    self.bgView.layer.shadowOffset = CGSizeMake(3, 3);
    self.bgView.layer.shadowRadius = 3.0;
}



@end
