//
//  LTxSipprMacroDef.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/5.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/PHAsset.h>
#ifndef LTxSipprMacroDef_h
#define LTxSipprMacroDef_h

typedef void (^LTxSipprCallbackBlock)(void);
typedef void (^LTxSipprBoolCallbackBlock)(BOOL);
typedef void (^LTxSipprFloatCallbackBlock)(CGFloat);
typedef void (^LTxSipprIntegerCallbackBlock)(NSInteger);
typedef void (^LTxSipprStringCallbackBlock)(NSString*);
typedef void (^LTxSipprDictionaryCallbackBlock)(NSDictionary*);
typedef void (^LTxSipprProgressCallbackBlock)(NSProgress*);
typedef void (^LTxSipprObjectCallbackBlock)(id);

typedef void (^LTxSipprBoolAndStringCallbackBlock)(BOOL,NSString*);
typedef void (^LTxSipprBoolAndObjectCallbackBlock)(BOOL,id);
typedef void (^LTxSipprArrayAndStringCallbackBlock)(NSArray*,NSString*);
typedef void (^LTxSipprDictionaryAndStringCallbackBlock)(NSDictionary*,NSString*);
typedef void (^LTxSipprObjectAndStringCallbackBlock)(id,NSString*);
typedef void (^LTxSipprImageAndURLCallbackBlock)(UIImage*,NSURL*);
typedef void (^LTxSipprImageURLAndPHAssetCallbackBlock)(UIImage*,NSURL*,PHAsset *);

typedef void (^LTxSipprBoolStringAndDictionaryCallbackBlock)(BOOL,NSString*,NSDictionary*);
typedef void (^LTxSipprBoolBoolDictionaryAndStringCallbackBlock)(BOOL,BOOL,NSDictionary*,NSString*);

#define SelfBundle  [NSBundle bundleForClass:[self class]]

#define LTxLocalizedString(key)  NSLocalizedStringFromTable(key,@"LT.bundle/Language/LT",nil)

#define LTxImageWithName(imageName)  [UIImage imageWithContentsOfFile: [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"LT.bundle/Images/%@",imageName] ofType:@"png"]]


/**
 * Notification 通知
 **/

#define LTX_NOTIFICATION_MSG_DID_SELECT_KEY @"LTx_Notification_Msg_Did_Select_Key"//消息被点击时发送的通知



#define LTxSipprNavigationBarItemHeight 24



#endif /* LTxSipprMacroDef_h */
