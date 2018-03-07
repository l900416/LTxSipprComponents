//
//  LTxSipprMsgTypeDetailTableViewCell.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/1/19.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprMsgTypeDetailTableViewCell.h"

@interface LTxSipprMsgTypeDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *stateImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *dateL;
@property (weak, nonatomic) IBOutlet UIImageView *attachImageView;
@end

@implementation LTxSipprMsgTypeDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setModel:(LTxSipprMsgOverviewModel *)model{
    _model = model;
    if (model) {
        if (model.readState) {
            self.stateImageView.image = [UIImage imageWithContentsOfFile: [SelfBundle pathForResource:@"LTxSipprComponents.bundle/Images/ic_msg_state_read" ofType:@"png"]];
        }else{
            self.stateImageView.image = [UIImage imageWithContentsOfFile: [SelfBundle pathForResource:@"LTxSipprComponents.bundle/Images/ic_msg_state_unread" ofType:@"png"]];
        }
        self.nameL.text = model.msgName;
        self.contentL.text = model.msgContent;
        self.dateL.text = [NSDate lt_timeDescriptionWithDateString:model.msgDate];
        if (model.hasAttachment) {
            self.attachImageView.hidden = NO;
            self.attachImageView.image = [UIImage imageWithContentsOfFile: [SelfBundle pathForResource:@"LTxSipprComponents.bundle/Images/ic_msg_extra_attachment" ofType:@"png"]];
        }else{
            self.attachImageView.hidden = YES;
        }
    }
}
@end
