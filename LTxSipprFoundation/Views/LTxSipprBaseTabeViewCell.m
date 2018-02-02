//
//  LTxSipprBaseTabeViewCell.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/1/19.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprBaseTabeViewCell.h"
#import "LTxSipprConfig.h"
@implementation LTxSipprBaseTabeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self setupCommonConfig];
}

-(void)setupCommonConfig{
    self.contentView.backgroundColor = [LTxSipprConfig sharedInstance].cellContentViewColor;
}

@end
