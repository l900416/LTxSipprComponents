//
//  LTxSipprMsgViewModel.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTxSipprConfig.h"

/*消息相关接口*/
@interface LTxSipprMsgViewModel : NSObject

/**
 * 推送定制 - 消息类别获取
 **/
+(void)pushTypeListFetchComplete:(LTxSipprArrayAndStringCallbackBlock)complete;

/**
 * 推送定制 - 定制消息类别
 **/
+(void)diyPushTypeList:(NSSet*)pushTypeSet complete:(LTxSipprStringCallbackBlock)complete;


/**
 * 消息 - 消息类别及该类别下未读的消息及数量
 **/
+(void)msgTypeOverviewListFetchComplete:(LTxSipprArrayAndStringCallbackBlock)complete;

/**
 * 消息 - 消息类别下的所有消息置为已读
 **/
+(void)updateMsgTypeReadStateWithMsgType:(NSString*)messageType complete:(LTxSipprCallbackBlock)complete;

/**
 * 消息 - 特定消息类别下的消息列表获取
 **/
+(void)msgListFetchWithMsgType:(NSString*)messageType currentPage:(NSInteger)currentPage maxResult:(NSInteger)maxResult complete:(LTxSipprArrayAndStringCallbackBlock)complete;

/**
 * 消息 - 特定的消息获取
 **/

+(void)msgDetailWithMsgId:(NSString*)messageId userNumber:(NSString*)userNumber complete:(LTxSipprDictionaryAndStringCallbackBlock)complete;

/**
 * 消息 - 将某一条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgId:(NSString*)messageId complete:(LTxSipprStringCallbackBlock)complete;

/**
 * 消息 - 将某一条消息的阅读状态置为已读
 **/
+(void)updateMsgReadStateWithMsgGuid:(NSString*)guid complete:(LTxSipprStringCallbackBlock)complete;

/**
 * 消息 - 根据业务编码获取消息详情
 **/
+(void)msgDetailWithMsgRowGuid:(NSString*)messageRowGuid complete:(LTxSipprDictionaryAndStringCallbackBlock)complete;

#pragma mark - SMS
/**
 * 发送验证码
 **/
+(void)sendSmsCode:(NSString*)phoneNumber operateType:(NSInteger)operateType complete:(LTxSipprStringCallbackBlock)complete;
/**
 * 发送验证码
 **/
+(void)validateSmsCode:(NSString*)phoneNumber authCode:(NSString*)authCode complete:(LTxSipprStringCallbackBlock)complete;

@end
