//
//  LTxSipprCameraQrcodeScanViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprCameraQrcodeScanViewController.h"
#import "LTxSipprCameraQrcodeScanView.h"
#import <AVFoundation/AVFoundation.h>
@interface LTxSipprCameraQrcodeScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (nonatomic, strong) LTxSipprCameraQrcodeScanView* scanView;
@property (nonatomic, assign) BOOL scanResult;
/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@end

@implementation LTxSipprCameraQrcodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupConfig];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    [self checkAVAuthorizationStatus];
    _scanResult = NO;
}

// 移除定时器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [LTxSipprConfig sharedInstance].skinColor;
    [self.scanView removeTimer];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),^{
        [self.session stopRunning];// 1、停止会话
        [self.previewLayer removeFromSuperlayer];// 2、删除预览图层
    });
}

#pragma mark - 二维码扫描

-(void)checkAVAuthorizationStatus{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(status == AVAuthorizationStatusAuthorized) {
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
        [self setupScanningQRCode];
#endif
        [self.scanView addTimer];
    }else if(status == AVAuthorizationStatusNotDetermined){
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
#if TARGET_IPHONE_SIMULATOR//模拟器
#elif TARGET_OS_IPHONE//真机
                [self setupScanningQRCode];
#endif
                [self.scanView addTimer];
            }else{
                [LTxSipprPopup  showToast:@"没有授权使用相机,无法进行二维码扫描。" onView:self.view];
            }
        }];
    }else{
        [LTxSipprPopup  showToast:@"没有使用相机权限，请在设备的'设置-隐私-相机'中允许访问相机。" onView:self.view];
    }
}

- (void)setupScanningQRCode {
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];// 1、获取摄像设备
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];// 2、创建输入流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];// 3、创建输出流
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];// 4、设置代理 在主线程里刷新
    output.rectOfInterest = CGRectMake(0.3, 0.3, 0.4, 0.4);// 设置扫描范围
    //光感传感器
    AVCaptureVideoDataOutput *videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    [videoDataOutput setSampleBufferDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc] init];// 5、初始化链接对象（会话对象）
    [_session setSessionPreset:AVCaptureSessionPresetHigh];// 高质量采集率
    [_session addInput:input];// 5.1 添加会话输入
    [_session addOutput:output];// 5.2 添加会话输出
    [_session addOutput:videoDataOutput];//光感传感器
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    //    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.layer.bounds;
    
    // 8、将图层插入当前视图
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
    // 9、启动会话
    [_session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    // 会频繁的扫描，调用代理方法
    if (_scanResult) {
        return;
    }
    if (metadataObjects.count > 0) {
        _scanResult = YES;
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self scanCompleteWithQRCode:obj.stringValue];
    }
}

#pragma mark- AVCaptureVideoDataOutputSampleBufferDelegate的方法
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    CFDictionaryRef metadataDict = CMCopyDictionaryOfAttachments(NULL,sampleBuffer, kCMAttachmentMode_ShouldPropagate);
    NSDictionary *metadata = [[NSMutableDictionary alloc] initWithDictionary:(__bridge NSDictionary*)metadataDict];
    CFRelease(metadataDict);
    NSDictionary *exifMetadata = [[metadata objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    float brightnessValue = [[exifMetadata objectForKey:(NSString *)kCGImagePropertyExifBrightnessValue] floatValue];
    if (brightnessValue < 0) {
        [self.scanView brightnessLight:YES];
    }else{
        [self.scanView brightnessLight:NO];
    }
}
#pragma mark - 相册
-(void)albumBtnAction{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
    imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
    imagePicker.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
}

#pragma mark - - - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:image];
    }];
}

/** 从相册中识别二维码, 并进行界面跳转 */
- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image {
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    BOOL find = false;
    for (CIQRCodeFeature *feature in features) {
        NSString *scannedResult = feature.messageString;
        [self scanCompleteWithQRCode:scannedResult];
        find = true;
        break;
    }
    if (!find) {
        [LTxSipprPopup showToast:@"二维码识别失败！" onView:self.view];
    }
}


#pragma mark - Action
//扫描完成
-(void)scanCompleteWithQRCode:(NSString*)qrCode{
    NSLog(@"扫描的二维码：%@",qrCode);
    if (_scanCompleteCallback) {
        _scanCompleteCallback(qrCode);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (![self.navigationController popViewControllerAnimated:true]) {
                [self dismissViewControllerAnimated:true completion:nil];
            };
        });
    }else{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scanResult = NO;
        });
    }
    
}


#pragma mark - Components
-(void)setupConfig{
    self.title = LTxSipprLocalizedStringWithKey(@"text_camera_qrcode_scan");
    
    UIButton* albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 26)];
    [albumBtn addTarget:self action:@selector(albumBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [albumBtn setTitle:@"相册" forState:UIControlStateNormal];
    [albumBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
    [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:albumBtn];
    
    _scanView = [[LTxSipprCameraQrcodeScanView alloc] init];
    _scanView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scanView];
    [self addConstraintsOnComponents];
}


-(void)addConstraintsOnComponents{
    NSLayoutConstraint* scanLeadingConstraint = [NSLayoutConstraint constraintWithItem:_scanView attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeadingMargin multiplier:1.f constant:-10];
    NSLayoutConstraint* scanTrailingConstraint = [NSLayoutConstraint constraintWithItem:_scanView attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailingMargin multiplier:1.f constant:10];
    NSLayoutConstraint* scanTopConstraint = [NSLayoutConstraint constraintWithItem:_scanView attribute:NSLayoutAttributeTopMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTopMargin multiplier:1.f constant:0];
    NSLayoutConstraint* scanBottomConstraint = [NSLayoutConstraint constraintWithItem:_scanView attribute:NSLayoutAttributeBottomMargin relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottomMargin multiplier:1.f constant:0];
    
    [NSLayoutConstraint activateConstraints:@[scanLeadingConstraint,scanTrailingConstraint,scanTopConstraint,scanBottomConstraint]];
}


@end
