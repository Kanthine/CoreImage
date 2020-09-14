//
//  ScanQRCodeViewController.swift
//  CoreImage-Swift
//
//  Created by 苏沫离 on 2017/9/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//
// 二维码扫描器

import UIKit
import Photos
import AVFoundation

protocol ScanQRCodeViewControllerDelegate {
    func scanResult(result:String,error:String)
}


class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate{

//    weak open var delegate: ScanQRCodeViewControllerDelegate?

    var device : AVCaptureDevice!
    var session : AVCaptureSession!
    var previewLayer : AVCaptureVideoPreviewLayer!
    
    lazy var qrCodeView : ScanQRCodeView = {
        let width = UIScreen.main.bounds.width / 3.0 * 2
        let x = (UIScreen.main.bounds.width - width) / 2.0;
        let y = (UIScreen.main.bounds.height - width) / 2.0;
        let aView = ScanQRCodeView.init(frame: view.bounds,scanRect: CGRect(x: x, y: y, width: width, height: width))
        return aView
    }()
    
    lazy var preView : UIView = {
        let aView = UIView(frame: view.bounds)
        aView.backgroundColor = UIColor.white
        return aView
    }()
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - life cycyle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preView.frame = view.bounds
    }
    
    // MARK: - response click
    @objc func leftBtnAction() {
    
    }
    @objc func rightBarButtonItenAction() {
    
    }
    @objc func flashButtonClick(sender : UIButton) {
    
    }
    
    // MARK: - private method
    
    func addTopButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "navBar_LeftButton_Back"), for: .normal)
        backButton.setImage(UIImage(named: "navBar_LeftButton_Back_Pressed"), for: .highlighted)
        backButton.addTarget(self, action: #selector(leftBtnAction), for: .touchUpInside)
        backButton.adjustsImageWhenHighlighted = false
        backButton.contentHorizontalAlignment = .left
        backButton.frame = CGRect(x: 10, y: 20, width: 60, height: 44)
        view.addSubview(backButton)
        
        let libraryButton = UIButton(type: .custom)
        libraryButton.setImage(UIImage(named: "navBar_Library"), for: .normal)
        libraryButton.addTarget(self, action: #selector(rightBarButtonItenAction), for: .touchUpInside)
        libraryButton.adjustsImageWhenHighlighted = false
        libraryButton.frame = CGRect(x: UIScreen.main.bounds.width - 120, y: 20, width: 60, height: 44)
        view.addSubview(libraryButton)

        let flashButton = UIButton(type: .custom)
        flashButton.setImage(UIImage(named: "navBar_FlashOff"), for: .normal)
        flashButton.setImage(UIImage(named: "navBar_FlashOn"), for: .selected)
        flashButton.addTarget(self, action: #selector(flashButtonClick(sender:)), for: .touchUpInside)
        flashButton.adjustsImageWhenHighlighted = false
        flashButton.frame = CGRect(x: UIScreen.main.bounds.width - 60, y: 20, width: 60, height: 44)
        view.addSubview(flashButton)

    }
 
    func initCaptureSession() {
        session = AVCaptureSession()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        device = AVCaptureDevice.default(for: .video)
        let input = AVCaptureDeviceInput(device: device)
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        
        let x = qrCodeView.scanRect.origin.x
        let width = qrCodeView.scanRect.width
        let y = qrCodeView.scanRect.origin.y
        output.rectOfInterest = CGRect(x: y / UIScreen.main.bounds.height, y: x / UIScreen.main.bounds.width, width: width / UIScreen.main.bounds.height, height: width / UIScreen.main.bounds.width)
        
        session.sessionPreset = .hd1920x1080
        if session.canSetSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        }else if session.canSetSessionPreset(.iFrame1280x720) {
            session.sessionPreset = .iFrame1280x720
        }else {
            session.sessionPreset = .high
        }
        session.addInput(input)
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.bounds
        
        preView.layer.addSublayer(previewLayer)
        session.startRunning()
        qrCodeView.startScanAnimation()
    }
}

//#pragma mark - private method

///** 播放完成回调函数
// *  @param soundID    系统声音ID
// *  @param clientData 回调时传递的数据
// */
//void soundCompleteCallback(SystemSoundID soundID, void *clientData){
//    NSLog(@"播放完成...");
//}
//
///** 扫描提示声 : 播放音效文件 */
//- (void)playSoundEffect:(NSString *)name{
//    // 获取音效
//    NSString *audioFile = [[NSBundle mainBundle] pathForResource:name ofType:nil];
//    NSURL *fileUrl = [NSURL fileURLWithPath:audioFile];
//    // 1、获得系统声音ID
//    SystemSoundID soundID = 0;
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
//    // 如果需要在播放完之后执行某些操作，可以调用如下方法注册一个播放完成回调函数
//    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
//    // 2、播放音频
//    AudioServicesPlaySystemSound(soundID); // 播放音效
//}
//
//- (void)tipPHAuthorizationStatusAuthorized{
//    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"⚠️ 警告" message:@"请去-> [设置 - 隐私 - 照片 - Demo] 打开访问开关" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
//
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
//                                    {}];
//    [actionSheet addAction:cancelAction];
//    [actionSheet addAction:confirmAction];
//    [self presentViewController:actionSheet animated:YES completion:nil];
//}
//
//- (void)scanQRCodeFromPhotosInTheAlbum:(UIImage *)image{
//    // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
//    // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
//    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh }];
//    // 取得识别结果
//    NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
//    [features enumerateObjectsUsingBlock:^(CIQRCodeFeature *feature, NSUInteger idx, BOOL * _Nonnull stop){
//        NSString *scannedResult = feature.messageString;
//        if (scannedResult && scannedResult.length){
//            NSLog(@"扫描结果 － － %@", scannedResult);
//            [self scanUrl:scannedResult];
//            *stop = YES;
//        }
//    }];
//}
//
//- (void)scanUrl:(NSString *)urlString{
//    if (self.delegate && [self.delegate respondsToSelector:@selector(scanResult:error:)]){
//        [self.delegate scanResult:urlString error:nil];
//        [self.navigationController popViewControllerAnimated:YES];
//    }
//}

//
//#pragma mark - lift cycle
//
//- (instancetype)init{
//    self = [super init];
//    if (self){
//        [self initCaptureSession];
//    }
//    return self;
//}
//
//- (void)viewDidLoad{
//    [super viewDidLoad];
//
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"相册" style:(UIBarButtonItemStyleDone) target:self action:@selector(rightBarButtonItenAction)];
//
//    [self.view addSubview:self.preView];
//    [self.view addSubview:self.qrCodeView];
//
//    [self addTopButton];
//}
//
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    if (self.session.isRunning == NO){
//        [self.preView.layer addSublayer:self.previewLayer];
//        [self.session startRunning];
//    }
//    [self.qrCodeView startScanAnimation];
//}


//
//#pragma mark - response click
//
//-(void)leftBtnAction{
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)flashButtonClick:(UIButton *)sender{
//    if ([_device hasTorch]){
//        sender.selected = !sender.selected;
//        [_device lockForConfiguration:nil];
//
//        if (sender.selected){
//            if ([_device hasTorch]){
//                [_device setTorchMode:AVCaptureTorchModeOn];
//            }
//        }else{
//            [_device setTorchMode: AVCaptureTorchModeOff];
//        }
//        [_device unlockForConfiguration];
//    }
//}
//
//
//- (void)rightBarButtonItenAction{
//    __weak __typeof__(self) weakSelf = self;
//
//    // 1、 获取摄像设备
//    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
//    if (device){
//        // 判断授权状态
//        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
//        if (status == PHAuthorizationStatusNotDetermined){
//            //用户还没有做出选择 -> 弹框请求用户授权
//            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
//                 if (status == PHAuthorizationStatusAuthorized){ // 用户点击允许
//                     dispatch_async(dispatch_get_main_queue(), ^{
//                        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
//                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
//                        imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
//                        [weakSelf presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
//                    });
//                 }else{
//                     // 用户第一次拒绝了访问相机权限
//                     NSLog(@"用户第一次拒绝了访问相册");
//                 }
//             }];
//
//        }else if (status == PHAuthorizationStatusAuthorized){ // 用户允许当前应用访问相册
//            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init]; // 创建对象
//            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; //（选择类型）表示仅仅从相册中选取照片
//            imagePicker.delegate = self; // 指定代理，因此我们要实现UIImagePickerControllerDelegate,  UINavigationControllerDelegate协议
//            [weakSelf presentViewController:imagePicker animated:YES completion:nil]; // 显示相册
//
//        } else if (status == PHAuthorizationStatusDenied){ // 用户拒绝当前应用访问相册
//            [weakSelf tipPHAuthorizationStatusAuthorized];
//        }else if (status == PHAuthorizationStatusRestricted){
//            NSLog(@"因为系统原因, 无法访问相册");
//        }
//    }else{
//        [weakSelf tipPHAuthorizationStatusAuthorized];
//    }
//}
//
//#pragma mark - AVCaptureMetadataOutputObjectsDelegate
//
///// 该代理代理方法，会频繁的扫描
//- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
//    // 0、扫描成功之后的提示音
//    [self playSoundEffect:@"sound.caf"];
//
//    // 1、如果扫描完成，停止会话
//    [self.session stopRunning];
//    [self.qrCodeView stopScanAnimation];
//
//    // 2、删除预览图层
//    [self.previewLayer removeFromSuperlayer];
//
//    // 3、设置界面显示扫描结果
//    if (metadataObjects.count > 0){
//        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
//        NSString *resultStr = obj.stringValue;
//        [self scanUrl:resultStr];
//    }
//}
//
//#pragma mark - UIImagePickerControllerDelegate
//
///// 从相册中识别二维码, 并进行界面跳转
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
//    NSLog(@"info - - - %@", info);
//    [self dismissViewControllerAnimated:YES completion:^{
//        [self scanQRCodeFromPhotosInTheAlbum:[info objectForKey:@"UIImagePickerControllerOriginalImage"]];
//    }];
//}
