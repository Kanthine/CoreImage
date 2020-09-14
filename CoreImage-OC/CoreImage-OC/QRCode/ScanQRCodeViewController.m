//
//  ScanQRCodeViewController.m
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "ScanQRCodeView.h"

#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface ScanQRCodeViewController ()
<AVCaptureMetadataOutputObjectsDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) AVCaptureDevice *device;
/** 会话对象 */
@property (nonatomic, strong) AVCaptureSession *session;
/** 图层类 */
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;

@property (nonatomic ,strong) UIView *preView;

@property (nonatomic ,strong) ScanQRCodeView *qrCodeView;

@end

@implementation ScanQRCodeViewController

#pragma mark - lift cycle

- (instancetype)init{
    self = [super init];
    if (self){
        [self initCaptureSession];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];

    [self.view addSubview:self.preView];
    [self.view addSubview:self.qrCodeView];

    [self addTopButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.session.isRunning == NO){
        [self.preView.layer addSublayer:self.previewLayer];
        [self.session startRunning];
    }
    [self.qrCodeView startScanAnimation];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.preView.frame = self.view.bounds;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)addTopButton{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navBar_LeftButton_Back_Pressed"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(leftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    backButton.adjustsImageWhenHighlighted = NO;
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backButton.frame = CGRectMake(10, 20, 60, 44);
    
    UIButton *libraryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [libraryButton setImage:[UIImage imageNamed:@"navBar_Library"] forState:UIControlStateNormal];
    [libraryButton addTarget:self action:@selector(rightBarButtonItenAction) forControlEvents:UIControlEventTouchUpInside];
    libraryButton.adjustsImageWhenHighlighted = NO;
    libraryButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 120, 20, 60, 44);

    
    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [flashButton setImage:[UIImage imageNamed:@"navBar_FlashOff"] forState:UIControlStateNormal];
    [flashButton setImage:[UIImage imageNamed:@"navBar_FlashOn"] forState:UIControlStateSelected];
    [flashButton addTarget:self action:@selector(flashButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    flashButton.adjustsImageWhenHighlighted = NO;
    flashButton.frame = CGRectMake(CGRectGetWidth(UIScreen.mainScreen.bounds) - 60, 20, 60, 44);

    
    [self.view addSubview:backButton];
    [self.view addSubview:libraryButton];
    [self.view addSubview:flashButton];
}

- (void)initCaptureSession{
    // 初始化链接对象（会话对象）
    self.session = [[AVCaptureSession alloc] init];
    // 实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    
    // 1、获取摄像设备
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    // 2、创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];
    
    // 3、创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    
    // 4、设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    // 设置扫描范围(每一个取值0～1，以屏幕右上角为坐标原点)
    // 要想限制二维码扫描区域，需要设置一个参数rectOfInterest 这个参数有点特别，这个参数的React 与平常设置的坐标系是完全相反的，即X与Y互换、W与H互换。
    
    CGFloat x = self.qrCodeView.scanRect.origin.x;
    CGFloat width = CGRectGetWidth(self.qrCodeView.scanRect);
    CGFloat y = self.qrCodeView.scanRect.origin.y;
    
    output.rectOfInterest = CGRectMake(y / CGRectGetHeight(UIScreen.mainScreen.bounds), x / CGRectGetWidth(UIScreen.mainScreen.bounds), width / CGRectGetHeight(UIScreen.mainScreen.bounds), width / CGRectGetWidth(UIScreen.mainScreen.bounds));
    
    // 5、初始化链接对象（会话对象）
    // 高质量采集率
    //session.sessionPreset = AVCaptureSessionPreset1920x1080; // 如果二维码图片过小、或者模糊请使用这句代码，注释下面那句代码
    if ([self.session canSetSessionPreset:AVCaptureSessionPreset1920x1080]){
        self.session.sessionPreset = AVCaptureSessionPreset1920x1080;
    }else if ([self.session canSetSessionPreset:AVCaptureSessionPreset1280x720]){
        self.session.sessionPreset = AVCaptureSessionPreset1280x720;
    }else{
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
    }
        
    // 5.1 添加会话输入
    [self.session addInput:input];
    
    // 5.2 添加会话输出
    [self.session addOutput:output];
    
    // 6、设置输出数据类型，需要将元数据输出添加到会话后，才能指定元数据类型，否则会报错
    // 设置扫码支持的编码格式(如下设置条形码和二维码兼容)
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode, AVMetadataObjectTypeEAN13Code,  AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
    
    // 7、实例化预览图层, 传递_session是为了告诉图层将来显示什么内容
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.previewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds));
    
    // 8、将图层插入当前视图
    [self.preView.layer addSublayer:self.previewLayer];
    // 9、启动会话
    [self.session startRunning];
    [self.qrCodeView startScanAnimation];
}

/** 播放完成回调函数
 *  @param soundID    系统声音ID
 *  @param clientData 回调时传递的数据
 */
void soundCompleteCallback(SystemSoundID soundID, void *clientData){
    NSLog(@"播放完成...");
}

/** 扫描提示声 : 播放音效文件 */
- (void)playSoundEffect:(NSString *)name{
    // 获取音效
    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
    // 1、获得系统声音ID
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    // 2、播放音频
    AudioServicesPlaySystemSound(soundID); // 播放音效
}

- (void)tipPHAuthorizationStatusAuthorized{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 照片 - Demo] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
                                    {}];
    [actionSheet addAction:cancelAction];
    [actionSheet addAction:confirmAction];
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image{
    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
    // 取得识别结果
    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    [features enumerateObjectsUsingBlock:^(CIQRCodeFeature *feature, NSUInteger idx, BOOL * _Nonnull stop){
        NSString *scannedResult = feature.messageString;
        if (scannedResult && scannedResult.length){
            NSLog(@"扫描结果 － － %@", scannedResult);
            [self scanUrl:scannedResult];
            *stop = YES;
        }
    }];
}

- (void)scanUrl:(NSString *)urlString{
    if (self.delegate && [self.delegate respondsToSelector:@selector(scanResult:error:)]){
        [self.delegate scanResult:urlString error:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - response click

-(void)leftBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)flashButtonClick:(UIButton *)sender{
    if ([_device hasTorch]){
        sender.selected = !sender.selected;
        [_device lockForConfiguration:nil];

        if (sender.selected){
            if ([_device hasTorch]){
                [_device setTorchMode:AVCaptureTorchModeOn];
            }
        }else{
            [_device setTorchMode: AVCaptureTorchModeOff];
        }
        [_device unlockForConfiguration];
    }
}


- (void)rightBarButtonItenAction{
    __weak __typeof__(self) weakSelf = self;
    
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device){
        // 判断授权状态
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusNotDetermined){
            //用户还没有做出选择 -> 弹框请求用户授权
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
                 if (status == PHAuthorizationStatusAuthorized){ // 用户点击允许
                     dispatch_async(dispatch_get_main_queue(), ^{
                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
                        imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
                        [weakSelf presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
                    });
                 }else{
                     // 用户第一次拒绝了访问相机权限
                     NSLog(@"用户第一次拒绝了访问相册");
                 }
             }];
            
        }else if (status == PHAuthorizationStatusAuthorized){ // 用户允许当前应用访问相册
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
            imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
            [weakSelf presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
            
        } else if (status == PHAuthorizationStatusDenied){ // 用户拒绝当前应用访问相册
            [weakSelf tipPHAuthorizationStatusAuthorized];
        }else if (status == PHAuthorizationStatusRestricted){
            NSLog(@"因为系统原因, 无法访问相册");
        }
    }else{
        [weakSelf tipPHAuthorizationStatusAuthorized];
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

/// 该代理代理方法，会频繁的扫描
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    // 0、扫描成功之后的提示音
    [self playSoundEffect:@"sound.caf"];
    
    // 1、如果扫描完成，停止会话
    [self.session stopRunning];
    [self.qrCodeView stopScanAnimation];

    // 2、删除预览图层
    [self.previewLayer removeFromSuperlayer];
    
    // 3、设置界面显示扫描结果
    if (metadataObjects.count > 0){
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        NSString *resultStr = obj.stringValue;
        [self scanUrl:resultStr];
    }
}

#pragma mark - UIImagePickerControllerDelegate

/// 从相册中识别二维码, 并进行界面跳转
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    NSLog(@"info - - - %@", info);
    [self dismissViewControllerAnimated:YES completion:^{
        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
    }];
}

#pragma mark - setters and getters

- (ScanQRCodeView *)qrCodeView{
    if (_qrCodeView == nil){
        CGFloat width = CGRectGetWidth(UIScreen.mainScreen.bounds) / 3.0 * 2;
        CGFloat x = (CGRectGetWidth(UIScreen.mainScreen.bounds) - width) / 2.0;
        CGFloat y = (CGRectGetHeight(UIScreen.mainScreen.bounds) - width) / 2.0;
        _qrCodeView = [[ScanQRCodeView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds)) scanRect:CGRectMake(x, y, width, width)];
    }
    return _qrCodeView;
}

- (UIView *)preView{
    if (_preView == nil){
        _preView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds), CGRectGetHeight(UIScreen.mainScreen.bounds))];
        _preView.backgroundColor = UIColor.whiteColor;
    }
    return _preView;
}

@end
