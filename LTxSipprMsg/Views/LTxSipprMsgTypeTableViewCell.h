//
//  LTxSipprMsgTypeTableViewCell.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/1/19.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprBaseTabeViewCell.h"
#import "LTxSipprMsgModel.h"

/**
 * 消息类别预览
 * 展示消息类别，未读数量，预览消息等
 **/
@interface LTxSipprMsgTypeTableViewCell : LTxSipprBaseTabeViewCell

@property (nonatomic, strong) LTxSipprMsgTypeModel* model;

@end
