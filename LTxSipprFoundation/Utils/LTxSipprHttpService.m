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
#import "LTxSipprConfig.h"
#import "LTxSipprCategories.h"


@interface LTxSipprHTTPSessionManager :AFHTTPSessionManager
@end

@implementation LTxSipprHTTPSessionManager
//重写方法，像Request中添加签名验证信息
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    if ([LTxSipprConfig sharedInstance].signature) {
        /*添加签名信息*/
        NSString* token = [LTxSipprConfig sharedInstance].signatureToken;
        NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        NSMutableString* stringBuffer = [[NSMutableString alloc] init];
        if ([parameters isKindOfClass:[NSDictionary class]]) {
            NSDictionary* parametersDic = (NSDictionary*)parameters;
            NSArray* sortedKeyArray = [parametersDic.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString* key1, NSString* key2)  {
                return [key1 compare:key2];
            }];
            for (NSString* key in sortedKeyArray) {
                id object = [parametersDic objectForKey:key];
                NSString* keyValueElement = [NSString stringWithFormat:@"&%@=%@",key,object];
                if (keyValueElement) {
                    [stringBuffer appendString:keyValueElement];
                }
            }
        }
        [stringBuffer insertString:[token substringToIndex:32] atIndex:0];
        [stringBuffer insertString:[NSString stringWithFormat:@"%.0f&",timestamp] atIndex:0];
        //对stringBuffer进行MD5加密，之后添加到Request中
        NSString* calcSgin = [stringBuffer jk_md5String];
        NSLog(@"\n***********calcSign加密***********\n前：%@\n后：%@\n",stringBuffer,calcSgin);
        
        [request setValue:token forHTTPHeaderField:@"token"];
        [request setValue:[NSString stringWithFormat:@"%.0f",timestamp] forHTTPHeaderField:@"timestamp"];
        [request setValue:calcSgin forHTTPHeaderField:@"sign"];
        
        NSLog(@"====================Request Header Log====================");
        NSLog(@"Content-Type = %@",[request valueForHTTPHeaderField:@"Content-Type"]);
        NSLog(@"accept-language = %@",[request valueForHTTPHeaderField:@"accept-language"]);
        NSLog(@"user-agent = %@",[request valueForHTTPHeaderField:@"user-agent"]);
        NSLog(@"token = %@",[request valueForHTTPHeaderField:@"token"]);
        NSLog(@"timestamp = %@",[request valueForHTTPHeaderField:@"timestamp"]);
        NSLog(@"sign = %@",[request valueForHTTPHeaderField:@"sign"]);
        NSLog(@"==========================================================");
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}

@end

@implementation LTxSipprHttpService

static LTxSipprHTTPSessionManager *_sharedManager;
+ (LTxSipprHTTPSessionManager*)sharedManager{
    static dispatch_once_t onceTokenLTxSipprHTTPSessionManager;
    dispatch_once(&onceTokenLTxSipprHTTPSessionManager, ^{
        _sharedManager = [LTxSipprHTTPSessionManager manager];
        _sharedManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain", nil];
        _sharedManager.requestSerializer.timeoutInterval = 30.f;
    });
    
    return _sharedManager;
}

+ (NSURLSessionDataTask*)doGetWithURL:(NSString*)url
                                param:(NSDictionary*)param
                             complete:(completeBlock)complete{
    LTxSipprHTTPSessionManager *manager  =  [LTxSipprHttpService sharedManager];
    
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
    LTxSipprHTTPSessionManager *manager  =  [LTxSipprHttpService sharedManager];
    
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
    LTxSipprHTTPSessionManager *manager  =  [LTxSipprHttpService sharedManager];
    
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
    LTxSipprHTTPSessionManager *manager  =  [LTxSipprHttpService sharedManager];
    
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
                              filePathArray:(NSArray*)filePathArray
                                   progress:( void (^)(NSProgress *progress))progress
                                   complete:(completeBlock)complete{
    
    LTxSipprHTTPSessionManager *manager = [LTxSipprHttpService sharedManager];
    
    return [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (NSURL* filePath in filePathArray) {
            NSString* fileName = filePath.path.lastPathComponent;
            [formData appendPartWithFileURL:filePath
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
