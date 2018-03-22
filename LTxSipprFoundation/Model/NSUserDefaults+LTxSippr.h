//
//  NSUserDefaults+LTxSippr.h
//  AFNetworking
//
//  Created by liangtong on 2018/3/22.
//

#import <Foundation/Foundation.h>

/**
 * HOST 相关
 **/
#define USERDEFAULT_APP_SERVICE_HOST @"USERDEFAULT_APP_SERVICE_HOST"//业务相关地址
#define USERDEFAULT_APP_MSG_HOST @"USERDEFAULT_APP_MSG_HOST"//消息服务业务地址
#define USERDEFAULT_APP_UPDATE_HOST @"USERDEFAULT_APP_UPDATE_HOST"//更新相关地址

/**
 * 用户相关
 **/
#define USERDEFAULT_USER_LOGIN_NAME @"USERDEFAULT_USER_LOGIN_NAME"
#define USERDEFAULT_USER_LOGIN_PASSWORD @"USERDEFAULT_USER_LOGIN_PASSWORD"
#define USERDEFAULT_USER_NUMBER @"USERDEFAULT_USER_NUMBER"
#define USERDEFAULT_USER_NAME @"USERDEFAULT_USER_NAME"
#define USERDEFAULT_USER_ROLE_NAME @"USERDEFAULT_USER_ROLE_NAME"

/**
 * 设置
 **/

@interface NSUserDefaults (LTxSippr)

///#begin
/**
 *    @brief    清空UserDefaults
 */
///#end
+(void)lt_removeDefaultAppObjects;

///#begin
/**
 *    @brief    获取UserDefaults中的特定key对应的值。
 *    @param     defaultName         key值
 */
///#end
+ (id)lt_objectForKey:(NSString *)defaultName;
///#begin
/**
 *    @brief    向UserDefaults中设置对应的Key－Value键值对。
 *    @param     value               value值
 *    @param     defaultName         key值
 */
///#end
+ (void)lt_setObject:(id)value forKey:(NSString *)defaultName;

@end
