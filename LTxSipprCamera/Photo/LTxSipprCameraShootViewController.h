//
//  LTxSipprCameraShootViewController.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/5.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprBaseViewController.h"

//视频类型
typedef NS_ENUM(NSUInteger, LTxSipprCameraShootExportVideoType) {
    //default
    LTxSipprCameraShootExportVideoTypeMov,
    LTxSipprCameraShootExportVideoTypeMp4,
};

@interface LTxSipprCameraShootViewController : LTxSipprBaseViewController

@property (nonatomic, copy) LTxSipprImageAndURLCallbackBlock shootDoneCallback;
@property (nonatomic, assign) LTxSipprCameraShootExportVideoType videoType;

@end
