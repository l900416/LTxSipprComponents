//
//  LTxSipprCameraQrcodeScanView.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <UIKit/UIKit.h>


#define LTXSIPPR_CAMERA_QRCODE_SCAN_VIEW_WIDTH 220

/**
 * 二维码扫描界面
 **/
@interface LTxSipprCameraQrcodeScanView : UIView

-(void)addTimer;
-(void)removeTimer;

-(void)brightnessLight:(BOOL)isNight;

@end
