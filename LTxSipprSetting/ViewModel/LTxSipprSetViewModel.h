//
//  LTxSipprSetViewModel.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTxSipprConfig.h"

@interface LTxSipprSetViewModel : NSObject

///#begin
/**
 *    @brief    用户反馈
 */
///#end
+(void)userFeedbackWithOpinion:(NSString*)opinion
                      complete:(LTxSipprStringCallbackBlock)complete;

///#begin
/**
 *    @brief    检查版本更新
 */
///#end
+(void)appUpdateCheckComplete:(LTxSipprBoolBoolAndStringCallbackBlock)complete;

///#begin
/**
 *    @brief    历史版本信息
 */
///#end
+(void)appUpdateHistoryFetchComplete:(LTxSipprArrayAndStringCallbackBlock)complete;
@end
