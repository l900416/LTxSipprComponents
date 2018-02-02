//
//  LTxSipprMsgTypeDetailTableViewCell.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/1/19.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprBaseTabeViewCell.h"
#import "LTxSipprMsgModel.h"
/**
 * 消息类别详情
 * 展示消息阅读状态，标题，预览消息等
 **/
@interface LTxSipprMsgTypeDetailTableViewCell : LTxSipprBaseTabeViewCell

@property (nonatomic, strong) LTxSipprMsgOverviewModel* model;

@end
