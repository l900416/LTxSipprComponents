//
//  LTxSipprConfig.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef void (^LTxSipprCallbackBlock)(void);
typedef void (^LTxSipprBoolCallbackBlock)(BOOL);
typedef void (^LTxSipprStringCallbackBlock)(NSString*);
typedef void (^LTxSipprDictionaryCallbackBlock)(NSDictionary*);
typedef void (^LTxSipprArrayAndStringCallbackBlock)(NSArray*,NSString*);
typedef void (^LTxSipprDictionaryAndStringCallbackBlock)(NSDictionary*,NSString*);


/**
 * Notification 通知
 **/

#define LTX_NOTIFICATION_MSG_DID_SELECT_KEY @"LTx_Notification_Msg_Did_Select_Key"//消息被点击时发送的通知


/**
 * 全局配置相关
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
@property (nonatomic, strong) UIColor* activityViewBackgroundColor;
@property (nonatomic, strong) UIColor* viewBackgroundColor;
@property (nonatomic, strong) UIColor* cellContentViewColor;

#pragma mark - host
@property (nonatomic, strong) NSString* messageHost;

#pragma mark - 系统配置
@property (nonatomic, strong) NSString* appId;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, assign) NSInteger pageSize;
@end
