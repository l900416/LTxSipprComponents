//
//  LTxSipprMacroDef.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/5.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#ifndef LTxSipprMacroDef_h
#define LTxSipprMacroDef_h

typedef void (^LTxSipprCallbackBlock)(void);
typedef void (^LTxSipprBoolCallbackBlock)(BOOL);
typedef void (^LTxSipprIntegerCallbackBlock)(NSInteger);
typedef void (^LTxSipprStringCallbackBlock)(NSString*);
typedef void (^LTxSipprDictionaryCallbackBlock)(NSDictionary*);
typedef void (^LTxSipprProgressCallbackBlock)(NSProgress*);
typedef void (^LTxSipprObjectCallbackBlock)(id);

typedef void (^LTxSipprBoolAndStringCallbackBlock)(BOOL,NSString*);
typedef void (^LTxSipprArrayAndStringCallbackBlock)(NSArray*,NSString*);
typedef void (^LTxSipprDictionaryAndStringCallbackBlock)(NSDictionary*,NSString*);
typedef void (^LTxSipprImageAndURLCallbackBlock)(UIImage*,NSURL*);

typedef void (^LTxSipprBoolBoolAndStringCallbackBlock)(BOOL,BOOL,NSString*);
typedef void (^LTxSipprBoolStringAndDictionaryCallbackBlock)(BOOL,NSString*,NSDictionary*);


#define SelfBundle  [NSBundle bundleForClass:[self class]]

//获取Bundle中的image
#define LTxSipprBundlePngImageWithName(imageName) ([UIImage imageWithContentsOfFile: [SelfBundle pathForResource:[NSString stringWithFormat:@"Frameworks/LTxSippr.framework/LTxSipprComponents.bundle/Images/%@",imageName] ofType:@"png"]]?:[UIImage imageWithContentsOfFile: [SelfBundle pathForResource:[NSString stringWithFormat:@"LTxSipprComponents.bundle/Images/%@",imageName] ofType:@"png"]])

/**
 * 语言配置
 **/
#define LTxSipprLocalizedStringWithKey(key)  NSLocalizedStringFromTableInBundle(key,@"Frameworks/LTxSippr.framework/LTxSipprComponents.bundle/Language/LTxSippr",[NSBundle mainBundle],nil)



/**
 * Notification 通知
 **/

#define LTX_NOTIFICATION_MSG_DID_SELECT_KEY @"LTx_Notification_Msg_Did_Select_Key"//消息被点击时发送的通知



#define LTxSipprNavigationBarItemHeight 24



#endif /* LTxSipprMacroDef_h */
