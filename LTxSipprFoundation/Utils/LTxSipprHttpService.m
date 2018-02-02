//
//  LTxSipprHttpService.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprHttpService.h"
#import "AFNetworking.h"
#import "LTxSipprCheckUtil.h"

@implementation LTxSipprHttpService

+ (NSURLSessionDataTask*)doGetWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(completeBlock)complete{
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    return [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doPostWithURL:(NSString*)url
                                 param:(NSDictionary*)param
                              complete:(completeBlock)complete{
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    return [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doPutWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(completeBlock)complete{
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    return [manager PUT:url parameters:param success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doDeleteWithURL:(NSString*)url
                                   param:(NSDictionary*)param
                                complete:(completeBlock)complete{
    AFHTTPSessionManager *manager  = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    manager.requestSerializer.timeoutInterval = 10.f;
    
    return [manager DELETE:url parameters:param success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

+ (NSURLSessionDataTask*)doMultiPostWithURL:(NSString *)url
                                      param:(NSDictionary*)param
                                  fileArray:(NSArray*)fileArray
                                   progress:( void (^)(NSProgress *progress))progress
                                   complete:(completeBlock)complete{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
    //    manager.requestSerializer.timeoutInterval = 20.f;
    
    return [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0;  i < [fileArray count]; ++i) {
            NSDictionary* fileItem = [fileArray objectAtIndex:i];
            NSURL* fileURL = [fileItem objectForKey:@"fileURL"];
            NSString* fileName = [fileItem objectForKey:@"fileName"];
            [formData appendPartWithFileURL:fileURL
                                       name:fileName
                                      error:nil];
        }
    } progress:^(NSProgress *uploadProgress){
        if (progress) {
            progress(uploadProgress);
        }
    } success:^(NSURLSessionDataTask *task, id _Nullable responseObject) {
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:responseObject
                                                     complete:complete];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError *error) {
        NSLog(@"\n网络访问异常：%s\n%@",__func__,error);
        [LTxSipprHttpService handleHttpResponseWithStatusCode:((NSHTTPURLResponse*)(task.response)).statusCode
                                               responseObject:nil
                                                     complete:complete];
    }];
}

#pragma mark - 数据检查/处理
+(void)handleHttpResponseWithStatusCode:(NSInteger)statusCode
                         responseObject:(id)responseObject
                               complete:(completeBlock)complete{
    NSString* errorTips = [LTxSipprCheckUtil errorTipsWithHttpStatusCode:statusCode responseDic:responseObject];
    NSDictionary* data;
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        data = [responseObject objectForKey:@"data"];
    }
    if (complete) {
        complete(data,errorTips);
    }
}

@end
