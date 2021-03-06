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
#import "LTxSipprMacroDef.h"
@interface LTxSipprPopup : NSObject


#pragma mark - Toast

/**
 * 在特定View上展示提示信息
 **/
+(void)showToast:(NSString*)msg onView:(UIView*)view;


#pragma mark - Alert

/**
 * 特定位置展示Alert
 **/
+(void)showAlertOnViewController:(UIViewController*)viewController
                      sourceView:(UIView*)sourceView//iPad
                      sourceRect:(CGRect)sourceRect//iPad
                           style:(UIAlertControllerStyle)style
                           title:(NSString*)title
                         message:(NSString*)message
                         actions:(UIAlertAction*)action,... NS_REQUIRES_NIL_TERMINATION;


@end
