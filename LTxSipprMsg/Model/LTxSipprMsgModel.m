//
//  LTxSipprMsgModel.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/1/19.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprMsgModel.h"

/**
 * 消息类别
 **/
@implementation LTxSipprMsgTypeModel

/**
 * Instance Method
 **/
+(instancetype)instanceWithMsgTypeId:(NSString*)msgTypeId imageName:(NSString *)imageName typeName:(NSString*)typeName msgCount:(NSInteger)msgCount msgOverview:(NSString*)msgOverview msgDate:(NSString*)msgDate{
    
    LTxSipprMsgTypeModel* _instance = [[LTxSipprMsgTypeModel alloc] init];
    
    _instance.msgTypeId = msgTypeId;
    _instance.msgImageName = imageName;
    _instance.msgTypeName = typeName;
    _instance.msgCount = msgCount;
    _instance.msgOverview = msgOverview;
    _instance.msgDate = msgDate;
    return _instance;
}

+(instancetype)instanceWithJSONString:(NSString*)jsonString{
    LTxSipprMsgTypeModel* _instance = [[LTxSipprMsgTypeModel alloc] init];
    
    //Convert String to Dictionary
    NSError* jsonError;
    NSDictionary *jsonDic =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if(!jsonError){
        [_instance setValuesForKeysWithDictionary:jsonDic];
    }
    
    return _instance;
}
+(instancetype)instanceWithDictionary:(NSDictionary*)dic{
    LTxSipprMsgTypeModel* _instance = [[LTxSipprMsgTypeModel alloc] init];
    if (dic) {
       [_instance setValuesForKeysWithDictionary:dic];
    }
    return _instance;
}

//映射用
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"msgTypeCode"]) {
        self.msgTypeId = value;
        self.msgImageName = [NSString stringWithFormat:@"ic_msg_type_%@",value];
    }else if ([key isEqualToString:@"unHandledCount"]) {
        self.msgCount = [value integerValue];
    }else if ([key isEqualToString:@"lastMsg"]) {
        self.msgOverview = [value objectForKey:@"lastContent"];
        self.msgDate = [value objectForKey:@"lastTime"];
    }
}
@end

/**
 * 消息详情
 **/
@implementation LTxSipprMsgOverviewModel

/**
 * Instance Method
 **/
+(instancetype)instanceWithMsgId:(NSString *)msgId stateImageName:(NSString*)stateImageName attachImageName:(NSString*)attachImageName msgName:(NSString*)msgName msgContent:(NSString*)msgContent msgDate:(NSString*)msgDate{
    
    LTxSipprMsgOverviewModel* _instance = [[LTxSipprMsgOverviewModel alloc] init];
    
    
    
    return _instance;
}

+(instancetype)instanceWithJSONString:(NSString*)jsonString{
    LTxSipprMsgOverviewModel* _instance = [[LTxSipprMsgOverviewModel alloc] init];

    //Convert String to Dictionary
    NSError* jsonError;
    NSDictionary *jsonDic =  [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
    if(!jsonError){
        [_instance setValuesForKeysWithDictionary:jsonDic];
    }
    
    return _instance;
}

+(instancetype)instanceWithDictionary:(NSDictionary*)dic{
    LTxSipprMsgOverviewModel* _instance = [[LTxSipprMsgOverviewModel alloc] init];
    if (dic) {
        [_instance setValuesForKeysWithDictionary:dic];
    }
    return _instance;
}

//映射用
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.msgId = value;
    }else if ([key isEqualToString:@"status"]) {
        NSInteger status = [value integerValue];
        if (status != 0) {//已读
            self.stateImageName = @"ic_msg_state_read";
        }else{//未读
            self.stateImageName = @"ic_msg_state_unread";
        }
    }else if ([key isEqualToString:@"extraFileCount"]) {//携带附件数量
        NSInteger extraFileCount = [value integerValue];
        if (extraFileCount > 0) {
            self.attachImageName = @"ic_msg_extra_attachment";
        }else{
            self.attachImageName = nil;
        }
    }else if ([key isEqualToString:@"title"]){
        self.msgName = value;
    }else if ([key isEqualToString:@"content"]){
        self.msgContent = value;
    }else if ([key isEqualToString:@"date"]){
        self.msgDate = value;
    }
}
@end
