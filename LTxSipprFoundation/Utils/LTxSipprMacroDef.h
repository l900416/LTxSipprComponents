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

#define LTxSipprBundleImagePath(fileName) [@"Frameworks/LTxSippr.framework/LTxSipprComponents.bundle/Images" stringByAppendingPathComponent:fileName]

#define LTxSipprBundlePngImageWithName(imageName) [UIImage imageWithContentsOfFile: [SelfBundle pathForResource:[NSString stringWithFormat:@"LTxSipprComponents.bundle/Images/%@",imageName] ofType:@"png"]]


/**
 * 宏定义
 **/
#define IS_DEBUG   YES
#define LTXSIPPR_CAMERA_ALBUM_SAVE_USE_CUSTOM   YES// 保存相片/视频时，是否使用自定义相册

/**
 * 语言配置
 **/
#define LTxSipprLocalizedStringWithKey(key)  NSLocalizedStringFromTableInBundle(key,@"Frameworks/LTxSippr.framework/LTxSipprComponents.bundle/Language/LTxSippr",[NSBundle mainBundle],nil)






#endif /* LTxSipprMacroDef_h */