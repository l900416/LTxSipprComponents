//
//  LTxSipprCategories.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/2.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprCategories.h"

#pragma mark - 日期
@implementation NSDate (LTxSipprExtension)


/**
 * @brief：日期描述
 * @return：x分钟前/x小时前/昨天/x天前/x个月前/x年前
 */
- (NSString *)lt_timeDescription{
    
    NSString* retTimeDesc;
    NSTimeInterval time =  [[NSDate date] timeIntervalSinceDate:self];
    if (time < LT_DATE_MINUTE) {//不到1分钟
        retTimeDesc = @"刚刚";
    }else if (time < LT_DATE_HOUR){//不到1小时
        retTimeDesc = [NSString stringWithFormat:@"%.0f分钟前",time / LT_DATE_MINUTE];
    }else if (time < LT_DATE_DAY){//不到1天
        retTimeDesc = [NSString stringWithFormat:@"%.0f小时前",time / LT_DATE_HOUR];
    }else if (time < LT_DATE_MONTH){//不到1月
        retTimeDesc = [NSString stringWithFormat:@"%.0f天前",time / LT_DATE_DAY];
    }else if (time < LT_DATE_YEAR){//不到1年
        retTimeDesc = [NSString stringWithFormat:@"%.0f个月前",time / LT_DATE_MONTH];
    }else{
        retTimeDesc = [NSString stringWithFormat:@"%.0f年前",time / LT_DATE_YEAR];
    }
    return retTimeDesc;
}
+ (NSString *)lt_timeDescriptionWithDateString:(NSString*)dateString{
    
    NSString* format = @"yyyy-MM-dd HH:mm:ss";
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:dateString];
    return [date lt_timeDescription];
}
@end
