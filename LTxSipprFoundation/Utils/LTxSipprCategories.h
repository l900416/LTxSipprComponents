//
//  LTxSipprCategories.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/2.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LT_DATE_MINUTE    60
#define LT_DATE_HOUR    3600
#define LT_DATE_DAY    86400
#define LT_DATE_MONTH    2592000
#define LT_DATE_YEAR    31556926

/**
 * 常用的扩展
 **/

#pragma mark - 日期
@interface NSDate (LTxSipprExtension)

/**
 * @brief：日期描述
 * @return：x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)lt_timeDescription;

+ (NSString *)lt_timeDescriptionWithDateString:(NSString*)dateString;

@end
