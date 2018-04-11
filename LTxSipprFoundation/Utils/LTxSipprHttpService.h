//
//  LTxSipprHttpService.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 直接对访问结果进行错误判断，返回前台所需数据，接口参数待调整
 **/

typedef void (^completeBlock)(id data, NSString* errorTips);

@interface LTxSipprHttpService : NSObject

+ (NSURLSessionDataTask*)doGetWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(completeBlock)complete;

+ (NSURLSessionDataTask*)doPostWithURL:(NSString*)url
                                 param:(NSDictionary*)param
                              complete:(completeBlock)complete;

+ (NSURLSessionDataTask*)doPutWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(completeBlock)complete;

+ (NSURLSessionDataTask*)doDeleteWithURL:(NSString*)url
                                   param:(NSDictionary*)param
                                complete:(completeBlock)complete;

+ (NSURLSessionDataTask*)doMultiPostWithURL:(NSString *)url
                                      param:(NSDictionary*)param
                              filePathArray:(NSArray*)filePathArray
                                   progress:( void (^)(NSProgress *progress))progress
                                   complete:(completeBlock)complete;

@end
