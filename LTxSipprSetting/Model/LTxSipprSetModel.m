//
//  LTxSipprSetModel.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/28.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprSetModel.h"

/**
 * 更新历史
 **/
@implementation LTxSipprSetUpdateHistoryModel : NSObject

/**
 * Instance Method
 **/
+(instancetype)instanceWithUpdateId:(NSString*)updateId displayVersion:(NSString *)displayVersion updateContent:(NSString*)updateContent{
    LTxSipprSetUpdateHistoryModel* _instance = [[LTxSipprSetUpdateHistoryModel alloc] init];
    
    _instance.updateId = updateId;
    _instance.displayVersion = displayVersion;
    _instance.updateContent = updateContent;
    return _instance;
}

+(instancetype)instanceWithJSONString:(NSString*)jsonString{
    LTxSipprSetUpdateHistoryModel* _instance = [[LTxSipprSetUpdateHistoryModel alloc] init];
    
    //Convert String to Dictionary
    NSError* jsonError;
    NSDictionary *jsonDic =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if(!jsonError){
        [_instance setValuesForKeysWithDictionary:jsonDic];
    }
    
    return _instance;
}
+(instancetype)instanceWithDictionary:(NSDictionary*)dic{
    LTxSipprSetUpdateHistoryModel* _instance = [[LTxSipprSetUpdateHistoryModel alloc] init];
    if (dic) {
        [_instance setValuesForKeysWithDictionary:dic];
    }
    return _instance;
}
//映射用
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"displayVer"]) {
        self.displayVersion = value;
    }else if ([key isEqualToString:@"updateContent"]) {
        self.updateContent = value;
    }else if ([key isEqualToString:@"updateVer"]) {
        self.updateId = value;
    }
}
@end
