//
//  LTxSipprCameraQrcodeScanViewController.m
//  LTxComponentsForSippr
//
//  Created by liangtong on 2018/3/1.
//  Copyright © 2018年 liangtong. All rights reserved.
//

#import "LTxSipprCameraQrcodeScanViewController.h"
#import "LTxSipprCameraUtil.h"
#import "SGQRCode.h"
#import <AVFoundation/AVFoundation.h>
@interface LTxSipprCameraQrcodeScanViewController ()<SGQRCodeScanManagerDelegate, SGQRCodeAlbumManagerDelegate>
@property (nonatomic, strong) SGQRCodeScanManager *manager;
@property (nonatomic, strong) SGQRCodeScanningView *scanningView;

@property (nonatomic, assign) BOOL scanResult;
@property (nonatomic, strong) UIButton* openFlashLightBtn;
@property (nonatomic, assign) BOOL openState;//用户打开灯光
@end

@implementation LTxSipprCameraQrcodeScanViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _scanResult = NO;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self checkAVAuthorizationStatus];
    [self.scanningView addTimer];
    self.navigationController.navigationBar.barTintColor = [UIColor clearColor];
    
}

// 移除定时器
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _scanResult = YES;
    self.navigationController.navigationBar.barTintColor = [LTxSipprConfig sharedInstance].skinColor;
    [self.scanningView removeTimer];
    [_manager cancelSampleBufferDelegate];
    [_manager videoPreviewLayerRemoveFromSuperlayer];
}

- (void)dealloc{
    [self removeScanningView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scanningView];
    
}

-(void)checkAVAuthorizationStatus{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        [self checkAVAuthorizationStatus];
                    } else {
                        [LTxSipprPopup  showToast:LTxLocalizedString(@"text_camera_authorization_do_deny") onView:self.navigationController.view];
                        [self.navigationController popViewControllerAnimated:true];
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                [self setupNavigationBar];
                [self setupQRCodeScanning];
                [self setupFlashRelatedConfig];
                [_manager startRunning];
                [_manager resetSampleBufferDelegate];
                break;
            }
            default:
                break;
        }
        return;
    }}

- (SGQRCodeScanningView *)scanningView {
    if (!_scanningView) {
        _scanningView = [[SGQRCodeScanningView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        _scanningView.scanningImageName = @"SGQRCode.bundle/QRCodeScanningLineGrid";
        _scanningView.scanningAnimationStyle = ScanningAnimationStyleGrid;
        _scanningView.cornerColor = [LTxSipprConfig sharedInstance].skinColor;
    }
    return _scanningView;
}
- (void)removeScanningView {
    [self.scanningView removeTimer];
    [self.scanningView removeFromSuperview];
    self.scanningView = nil;
}

- (void)setupQRCodeScanning {
    self.manager = [SGQRCodeScanManager sharedManager];
    NSArray *arr = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    // AVCaptureSessionPreset1920x1080 推荐使用，对于小型的二维码读取率较高
    [_manager setupSessionPreset:AVCaptureSessionPreset1920x1080 metadataObjectTypes:arr currentController:self];
    [_manager cancelSampleBufferDelegate];
    _manager.delegate = self;
}

#pragma mark - 从相册中选照片
- (void)setupNavigationBar {
    self.navigationItem.title = @"扫码";
    UIButton* albumBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 42, 26)];
    [albumBtn addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    [albumBtn setTitle:LTxLocalizedString(@"text_camera_album") forState:UIControlStateNormal];
    [albumBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:17.f]];
    [albumBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:albumBtn];
}

- (void)rightBarButtonItenAction {
    SGQRCodeAlbumManager *manager = [SGQRCodeAlbumManager sharedManager];
    [manager readQRCodeFromAlbumWithCurrentController:self];
    manager.delegate = self;
    
    if (manager.isPHAuthorization == YES) {
        [self.scanningView removeTimer];
    }
}

- (void)QRCodeAlbumManagerDidCancelWithImagePickerController:(SGQRCodeAlbumManager *)albumManager {
    [self.view addSubview:self.scanningView];
}
- (void)QRCodeAlbumManager:(SGQRCodeAlbumManager *)albumManager didFinishPickingMediaWithResult:(NSString *)result {
    NSLog(@"%s",__func__);
    _scanResult = YES;
    [self scanCompleteWithQRCode:result complete:^{
        _scanResult = NO;
    }];
}
- (void)QRCodeAlbumManagerDidReadQRCodeFailure:(SGQRCodeAlbumManager *)albumManager {
    NSLog(@"暂未识别出二维码");
    _scanResult = NO;
}

#pragma mark - 相机扫描
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager didOutputMetadataObjects:(NSArray *)metadataObjects {
    if(_scanResult){
        return;
    }
    NSLog(@"metadataObjects - - %@", metadataObjects);
    if (metadataObjects != nil && metadataObjects.count > 0) {
        _scanResult = YES;
        [scanManager playSoundName:@"SGQRCode.bundle/sound.caf"];
        [scanManager stopRunning];
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        [self scanCompleteWithQRCode:[obj stringValue] complete:^{
            _scanResult = NO;
        }];
    } else {
        NSLog(@"暂未识别出扫描的二维码");
    }
}
- (void)QRCodeScanManager:(SGQRCodeScanManager *)scanManager brightnessValue:(CGFloat)brightnessValue{
    if (brightnessValue < 0) {
        [self brightnessLight:YES];
    }else{
        [self brightnessLight:NO];
    }
}


-(void)scanCompleteWithQRCode:(NSString*)qrCode complete:(LTxSipprCallbackBlock)complete{
    if (_scanCompleteCallback) {
        _scanCompleteCallback(qrCode);
    }
    if(complete){
        complete();
    }
}


#pragma mark UI
-(void)setupFlashRelatedConfig{
    _openFlashLightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _openFlashLightBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [_openFlashLightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_openFlashLightBtn setBackgroundColor:[UIColor clearColor]];
    [_openFlashLightBtn addTarget:self action:@selector(openFlashLightAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_openFlashLightBtn];
    
    [self.view bringSubviewToFront:_openFlashLightBtn];
    
    
    //OpenFlashLightBtn
    NSLayoutConstraint* openBtnXConstraint = [NSLayoutConstraint constraintWithItem:self.openFlashLightBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.f constant:0];
    NSLayoutConstraint* openBtnYConstraint = [NSLayoutConstraint constraintWithItem:self.openFlashLightBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.f constant:40];
    NSLayoutConstraint* openBtnWidth = [NSLayoutConstraint constraintWithItem:self.openFlashLightBtn attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:50];
    NSLayoutConstraint* openBtnHeight = [NSLayoutConstraint constraintWithItem:self.openFlashLightBtn attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:50];

    [NSLayoutConstraint activateConstraints: @[openBtnXConstraint,openBtnYConstraint,openBtnWidth,openBtnHeight]];
    
}

-(void)brightnessLight:(BOOL)isNight{
    
    if (isNight) {
        if (_openState) {
            [_openFlashLightBtn setImage:[UIImage imageNamed:@"ic_flash_light_close"] forState:UIControlStateNormal];
        }else{
            [_openFlashLightBtn setImage:[UIImage imageNamed:@"ic_flash_light_open"] forState:UIControlStateNormal];
        }
        _openFlashLightBtn.hidden = NO;
    }else{
        if (_openState) {
            [_openFlashLightBtn setImage:[UIImage imageNamed:@"ic_flash_light_close"] forState:UIControlStateNormal];
            _openFlashLightBtn.hidden = NO;
        }else{
            _openFlashLightBtn.hidden = YES;
        }
    }
    [_openFlashLightBtn setNeedsDisplay];
}

/*控制灯光*/
-(void)openFlashLight:(BOOL)open{
    if (open) {
        [LTxSipprCameraUtil openFlashlight];
    }else{
        [LTxSipprCameraUtil closeFlashlight];
    }
    _openState = open;
}

-(void)openFlashLightAction:(UIButton*)btn{
    if (_openState) {
        [self openFlashLight:NO];
    }else{
        [self openFlashLight:YES];
    }
    
}
@end
