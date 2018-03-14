//
//  LTxSipprMacroDef.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/5.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#ifndef LTxSipprMacroDef_h
#define LTxSipprMacroDef_h

typedef void (^LTxSipprCallbackBlock)(void);
typedef void (^LTxSipprBoolCallbackBlock)(BOOL);
typedef void (^LTxSipprStringCallbackBlock)(NSString*);
typedef void (^LTxSipprDictionaryCallbackBlock)(NSDictionary*);
typedef void (^LTxSipprProgressCallbackBlock)(NSProgress*);

typedef void (^LTxSipprArrayAndStringCallbackBlock)(NSArray*,NSString*);
typedef void (^LTxSipprDictionaryAndStringCallbackBlock)(NSDictionary*,NSString*);
typedef void (^LTxSipprImageAndURLCallbackBlock)(UIImage*,NSURL*);

typedef void (^LTxSipprBoolBoolAndStringCallbackBlock)(BOOL,BOOL,NSString*);


#define SelfBundle  [NSBundle bundleForClass:[self class]]

//获取Bundle中的image
#define LTxSipprBundlePngImageWithName(imageName) [UIImage imageWithContentsOfFile: [SelfBundle pathForResource:[NSString stringWithFormat:@"LTxSipprComponents.bundle/Images/%@",imageName] ofType:@"png"]]

//测试用
#define TEST_LTxSipprBundleImage(imageName) [UIImage imageNamed:[@"LTxSipprComponents.bundle/Images" stringByAppendingPathComponent:imageName]]

/**
 * 语言配置
 **/
#define LTxSipprLocalizedStringWithKey(key)  NSLocalizedStringFromTableInBundle(key,@"Frameworks/LTxSippr.framework/LTxSipprComponents.bundle/Language/LTxSippr",[NSBundle mainBundle],nil)



/**
 * Notification 通知
 **/

#define LTX_NOTIFICATION_MSG_DID_SELECT_KEY @"LTx_Notification_Msg_Did_Select_Key"//消息被点击时发送的通知







#endif /* LTxSipprMacroDef_h */
