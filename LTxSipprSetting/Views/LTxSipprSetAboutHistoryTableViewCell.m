//
//  LTxSipprSetAboutHistoryTableViewCell.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprSetAboutHistoryTableViewCell.h"

@interface LTxSipprSetAboutHistoryTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *versionL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@end

@implementation LTxSipprSetAboutHistoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(LTxSipprSetUpdateHistoryModel *)model{
    _model = model;
    if (model) {
        self.versionL.text = model.displayVersion;
        self.contentL.text = model.updateContent;
    }
}

@end
