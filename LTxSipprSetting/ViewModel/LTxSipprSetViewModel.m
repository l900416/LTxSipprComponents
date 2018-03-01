//
//  LTxSipprSetViewModel.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprSetViewModel.h"
#import "LTxSipprHttpService.h"

@implementation LTxSipprSetViewModel

///#begin
/**
 *    @brief    用户反馈
 */
///#end
+(void)userFeedbackWithOpinion:(NSString*)opinion
                      complete:(LTxSipprStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxSipprConfig* config = [LTxSipprConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"feedbackUserNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    [params setObject:@"iOS" forKey:@"platform"];
    
    id appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (appVersion) {
        [params setObject:appVersion forKey:@"appVer"];
    }
    if (opinion) {
        [params setObject:opinion forKey:@"feedbackContent"];
    }
    NSString* url = [NSString stringWithFormat:@"%@/eepm/v1/api/feedback",config.baseHost];
    //网络访问
    [LTxSipprHttpService doPostWithURL:url param:params complete:^(id data, NSString *errorTips) {
        if (complete) {
            complete(errorTips);
        }
    }];
}

///#begin
/**
 *    @brief    检查版本更新
 */
///#end
+(void)appUpdateCheckComplete:(LTxSipprBoolBoolAndStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxSipprConfig* config = [LTxSipprConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"userNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    [params setObject:@"iOS" forKey:@"platform"];
    
    id appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (appVersion) {
        [params setObject:appVersion forKey:@"currentVer"];
    }

    NSString* url = [NSString stringWithFormat:@"%@/eepm/v1/api/update",config.baseHost];
    //网络访问
    [LTxSipprHttpService doGetWithURL:url param:params complete:^(id data, NSString *errorTips) {
        if (complete) {
            NSDictionary* updateInfo = nil;
            if ([data isKindOfClass:[NSArray class]]) {
                updateInfo = [data objectAtIndex:0];
            }
            BOOL newVersionExists = [[updateInfo objectForKey:@"needUpdate"] boolValue];
            BOOL updateForced = false;
            if (newVersionExists){
                updateForced = [[updateInfo objectForKey:@"forceUpdate"] boolValue];
            }
            complete(newVersionExists,updateForced,errorTips);
        }
    }];
}

///#begin
/**
 *    @brief    历史版本信息
 */
///#end
+(void)appUpdateHistoryFetchComplete:(LTxSipprArrayAndStringCallbackBlock)complete{
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    LTxSipprConfig* config = [LTxSipprConfig sharedInstance];
    if (config.userId) {
        [params setObject:config.userId forKey:@"userNumber"];
    }
    if (config.appId) {
        [params setObject:config.appId forKey:@"appId"];
    }
    [params setObject:@"iOS" forKey:@"platform"];
    
    id appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    if (appVersion) {
        [params setObject:appVersion forKey:@"currentVer"];
    }
    
    NSString* url = [NSString stringWithFormat:@"%@/eepm/v1/api/updateHistory",config.baseHost];
    //网络访问
    [LTxSipprHttpService doGetWithURL:url param:params complete:^(id data, NSString *errorTips) {
        if (complete) {
            complete(data,errorTips);
        }
    }];
}

@end
