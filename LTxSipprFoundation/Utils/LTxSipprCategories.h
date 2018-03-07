//
//  LTxSipprCategories.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/2.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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


#pragma mark - 字符串
@interface NSString (LTxSipprExtension)

/**
 *  @brief  去除空格
 *  @return 去除空格后的字符串
 */
- (NSString *)lt_trimmingWhitespace;

//正则表达式
- (BOOL)lt_isValidateByRegex:(NSString *)regex;

/**
 *  手机号码的有效性:分电信、联通、移动和小灵通
 */
- (BOOL)lt_isMobileNumberClassification;
/**
 *  手机号有效性
 */
- (BOOL)lt_isMobileNumber;

/**
 *  邮箱的有效性
 */
- (BOOL)lt_isEmailAddress;

/**
 *  简单的身份证有效性
 *
 */
- (BOOL)lt_simpleVerifyIdentityCardNum;

/**
 *  精确的身份证号码有效性检测
 *
 *  @param value 身份证号
 */
+ (BOOL)lt_accurateVerifyIDCardNumber:(NSString *)value;

/**
 *  车牌号的有效性
 */
- (BOOL)lt_isCarNumber;

/**
 *  银行卡的有效性
 */
- (BOOL)lt_bankCardluhmCheck;

/**
 *  IP地址有效性
 */
- (BOOL)lt_isIPAddress;

/**
 *  Mac地址有效性
 */
- (BOOL)lt_isMacAddress;

/**
 *  网址有效性
 */
- (BOOL)lt_isValidUrl;

/**
 *  纯汉字
 */
- (BOOL)lt_isValidChinese;

/**
 *  邮政编码
 */
- (BOOL)lt_isValidPostalcode;

/**
 *  工商税号
 */
- (BOOL)lt_isValidTaxNo;
/**
 @brief     是否符合最小长度、最长长度，是否包含中文,首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)lt_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

/**
 @brief     是否符合最小长度、最长长度，是否包含中文,数字，字母，其他字符，首字母是否可以为数字
 @param     minLenth 账号最小长度
 @param     maxLenth 账号最长长度
 @param     containChinese 是否包含中文
 @param     containDigtal   包含数字
 @param     containLetter   包含字母
 @param     containOtherCharacter   其他字符
 @param     firstCannotBeDigtal 首字母不能为数字
 @return    正则验证成功返回YES, 否则返回NO
 */
- (BOOL)lt_isValidWithMinLenth:(NSInteger)minLenth
                      maxLenth:(NSInteger)maxLenth
                containChinese:(BOOL)containChinese
                 containDigtal:(BOOL)containDigtal
                 containLetter:(BOOL)containLetter
         containOtherCharacter:(NSString *)containOtherCharacter
           firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;


@end


