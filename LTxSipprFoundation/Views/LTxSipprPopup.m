//
//  LTxSipprPopup.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprPopup.h"
#import "LTxSipprConfig.h"

@implementation LTxSipprPopup

#pragma mark - Toast
/**
 * 在特定View上展示提示信息
 **/
+(void)showToast:(NSString*)msg onView:(UIView*)view{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.messageFont = [UIFont systemFontOfSize:16.0];
    style.messageColor = [UIColor whiteColor];
    style.messageAlignment = NSTextAlignmentCenter;
    style.backgroundColor = [LTxSipprConfig sharedInstance].hintColor;
    
    [CSToastManager setSharedStyle:style];
    [CSToastManager setQueueEnabled:NO];
    
    // - position: [NSValue valueWithCGPoint:CGPointMake(110, 110)]
    [view hideAllToasts];
    dispatch_async(dispatch_get_main_queue(), ^{
        [view makeToast:msg duration:3.0 position:CSToastPositionBottom style:style];
    });
}
@end
