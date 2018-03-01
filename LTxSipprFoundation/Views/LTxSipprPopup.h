//
//  LTxSipprPopup.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Toast/UIView+Toast.h>
@interface LTxSipprPopup : NSObject


#pragma mark - Toast
/**
 * 在特定View上展示提示信息
 **/
+(void)showToast:(NSString*)msg onView:(UIView*)view;
@end
