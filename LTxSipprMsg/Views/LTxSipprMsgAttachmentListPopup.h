//
//  LTxSipprMsgAttachmentListPopup.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/26.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTxSipprConfig.h"

/**
 * 消息附件列表弹出框
 **/
@interface LTxSipprMsgAttachmentListPopup : UIView


@property (nonatomic, copy) LTxSipprCallbackBlock closeAction;
@property (nonatomic, copy) LTxSipprDictionaryCallbackBlock filePreviewBlock;

-(void)setupWithFileList:(NSArray*)fileList;

@end
