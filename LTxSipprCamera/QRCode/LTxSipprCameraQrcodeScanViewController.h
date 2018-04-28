//
//  LTxSipprCameraQrcodeScanViewController.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprBaseViewController.h"
#import <AVFoundation/AVFoundation.h>

/**
 * 二维码/条形码扫描
 **/
@interface LTxSipprCameraQrcodeScanViewController : LTxSipprBaseViewController

@property (nonatomic, copy) LTxSipprStringCallbackBlock scanCompleteCallback;


@end
