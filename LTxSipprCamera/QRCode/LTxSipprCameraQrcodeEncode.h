//
//  LTxSipprCameraQrcodeEncode.h
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 * 二维码生成器
 **/
@interface LTxSipprCameraQrcodeEncode : NSObject

//填充以黑色的二维码
+(void)fillQRImageWithImageView:(UIImageView*)imageView qrString:(NSString*)qrString;

//获取二维码图片
+(UIImage*)createQRImageWithString:(NSString*)qrString size:(CGFloat)size red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;

@end
