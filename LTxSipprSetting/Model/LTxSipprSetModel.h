//
//  LTxSipprSetModel.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/28.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 更新历史
 **/
@interface LTxSipprSetUpdateHistoryModel : NSObject

/**
 * 编码
 **/
@property (nonatomic, copy) NSString* updateId;

/**
 * 版本
 **/
@property (nonatomic, copy) NSString* displayVersion;

/**
 * 内容
 **/
@property (nonatomic, copy) NSString* updateContent;

/**
 * Instance Method
 **/
+(instancetype)instanceWithUpdateId:(NSString*)updateId displayVersion:(NSString *)displayVersion updateContent:(NSString*)updateContent;

+(instancetype)instanceWithJSONString:(NSString*)jsonString;
+(instancetype)instanceWithDictionary:(NSDictionary*)dic;

@end
