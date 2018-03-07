//
//  LTxSipprConfig.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LTxSipprMacroDef.h"






/**
 * Notification 通知
 **/

#define LTX_NOTIFICATION_MSG_DID_SELECT_KEY @"LTx_Notification_Msg_Did_Select_Key"//消息被点击时发送的通知





/**
 * 配置相关
 **/
@interface LTxSipprConfig : NSObject

/**
 * 单例模式
 **/
+ (instancetype)sharedInstance;

/**
 * 系统初始化
 **/
- (void)appSetup;

#pragma mark - 颜色
@property (nonatomic, strong) UIColor* skinColor;
@property (nonatomic, strong) UIColor* hintColor;
@property (nonatomic, strong) UIColor* activityViewBackgroundColor;
@property (nonatomic, strong) UIColor* viewBackgroundColor;
@property (nonatomic, strong) UIColor* cellContentViewColor;

#pragma mark - host
@property (nonatomic, strong) NSString* messageHost;
@property (nonatomic, strong) NSString* baseHost;

#pragma mark - 系统配置
@property (nonatomic, strong) NSString* appId;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, assign) NSInteger pageSize;

#pragma mark - 其他
@property (nonatomic, strong) NSString* instalUrl;
@property (nonatomic, strong) NSString* instalTip;
@end
