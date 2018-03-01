//
//  LTxSipprConfig.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/2/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprConfig.h"

@implementation LTxSipprConfig

/**
 * 单例模式
 **/
static LTxSipprConfig *_instance;
+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[LTxSipprConfig alloc] init];
        [_instance setupInitValues];
    });
    
    return _instance;
}

/**
 * 系统初始化
 **/
- (void)appSetup{
    //NavigationBar 字体颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    [[UINavigationBar appearance] setBarTintColor:_skinColor];
}

/*默认设置*/
-(void)setupInitValues{
    /*颜色*/
    _skinColor = [UIColor colorWithRed:59/255.0 green:145/255.0 blue:233/255.0 alpha:1];
    _activityViewBackgroundColor = [UIColor lightGrayColor];
    _viewBackgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
    _cellContentViewColor = [UIColor colorWithRed:230.0/255.0 green:230.0/255.0 blue:230.0/255.0 alpha:1];
    
    /*HOST*/
    _messageHost = @"http://125.46.29.147:8852/eepj_push";
    _baseHost = @"http://125.46.29.147:8851";
    
    /*系统配置*/
    _appId = @"4f424ed4-b0f1-4af7-9567-aef6cd23d01a";
    _userId = @"sa00000004/b418d14ae6ad";
    _pageSize = 20;
}
@end
