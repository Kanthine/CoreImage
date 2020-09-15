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

protocol ScanQRCodeViewControllerDelegate : NSObject{
    func scanResult(result:String,error:String)
}


class ScanQRCodeViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate,
UINavigationControllerDelegate, UIImagePickerControllerDelegate{

    weak open var delegate: ScanQRCodeViewControllerDelegate?

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
    
    
    // MARK: - life cycyle
    init() {
        super.init(nibName: nil, bundle: nil)
        initCaptureSession()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "相册", style: .done, target: self, action: #selector(rightBarButtonItenAction))
        view.addSubview(preView)
        view.addSubview(qrCodeView)
        
        addTopButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        if !session.isRunning {
            preView.layer.addSublayer(previewLayer)
            session.startRunning()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        qrCodeView.startScanAnimation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        preView.frame = view.bounds
    }
    
    // MARK: - response click
    @objc func leftBtnAction() {
        navigationController?.popViewController(animated: true)
    }

    @objc func flashButtonClick(sender : UIButton) {
        if device.hasTorch {
            sender.isSelected = !sender.isSelected
            do{
                try device.lockForConfiguration()
                if sender.isSelected {
                    if device.hasTorch {
                        device.torchMode = .on
                    }
                }else{
                    device.torchMode = .off
                }
                device.unlockForConfiguration()
            }catch {
                
            }
        }
    }
    
    @objc func rightBarButtonItenAction() {
        if AVCaptureDevice.default(for: .video) != nil {
            let status = PHPhotoLibrary.authorizationStatus()
            if status == PHAuthorizationStatus.notDetermined {
                //用户还没有做出选择 -> 弹框请求用户授权
                PHPhotoLibrary.requestAuthorization { (status : PHAuthorizationStatus) in
                    if status == PHAuthorizationStatus.authorized { // 用户点击允许
                        DispatchQueue.main.async {
                            let imagePicker = UIImagePickerController()
                            imagePicker.sourceType = .photoLibrary
                            imagePicker.delegate = self
                            self.present(imagePicker, animated: true, completion: nil)
                        }
                    }else{
                        // 用户第一次拒绝了访问相机权限
                        print("用户第一次拒绝了访问相册")
                    }
                }
            }else if status == PHAuthorizationStatus.authorized {
                // 用户允许当前应用访问相册
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .photoLibrary
                imagePicker.delegate = self
                self.present(imagePicker, animated: true, completion: nil)
            }else if status == PHAuthorizationStatus.denied {
                // 用户拒绝当前应用访问相册
                tipPHAuthorizationStatusAuthorized()
            }else if status == PHAuthorizationStatus.restricted {
                print("因为系统原因, 无法访问相册")
            }
             
        }else{
            tipPHAuthorizationStatusAuthorized()
        }
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
        
        do{
            let input:AVCaptureDeviceInput = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        }catch {
            
        }
        session.addOutput(output)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr,AVMetadataObject.ObjectType.ean13,
                                      AVMetadataObject.ObjectType.ean8,AVMetadataObject.ObjectType.code128]
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = view.bounds
        
        preView.layer.addSublayer(previewLayer)
        session.startRunning()
        qrCodeView.startScanAnimation()
    }
    
    /** 播放完成回调函数
     *  @param soundID    系统声音ID
     *  @param clientData 回调时传递的数据
     */
    func soundCompleteCallback(soundID : SystemSoundID ,_:UnsafeMutableRawPointer) {
        print("播放完成...")
    }
    ///扫描提示声 : 播放音效文件
    func playSoundEffect(name : String) {
        if let audioFile = Bundle.main.path(forResource: name, ofType: nil) {
            let fileUrl = NSURL(fileURLWithPath: audioFile)
            //获得系统声音ID
            var soundID : SystemSoundID = 0
            AudioServicesCreateSystemSoundID(fileUrl, &soundID)
            ///注册播放完成的回调函数
            //AudioServicesAddSystemSoundCompletion(soundID, nil, nil, soundCompleteCallback(soundID: soundID, _), nil)
            AudioServicesPlaySystemSound(soundID)
        }
    }
    
    func tipPHAuthorizationStatusAuthorized() {
        let alertController = UIAlertController(title: "⚠️ 警告", message: "请去-> [设置 - 隐私 - 照片 - Demo] 打开访问开关", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (action : UIAlertAction) in
            
        }
        let confirmAction = UIAlertAction(title: "确定", style: .default) { (action : UIAlertAction) in
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func scanQRCodeFromPhotosInTheAlbum(image : UIImage)  {
        /// CIDetector 用于图片解析
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        /// 取得识别结果
        let features : [CIQRCodeFeature] = (detector?.features(in: image.ciImage!))! as! [CIQRCodeFeature]
        for feature in features {
            if  let scannedResult = feature.messageString {
                scanUrl(urlString: scannedResult as String)
                break
            }
        }
    }
    func scanUrl(urlString : String) {
        print("scan ----- " + urlString)
        guard (delegate != nil) else { return }
        delegate?.scanResult(result: urlString, error: "")
        navigationController?.popViewController(animated: true)
    }
    
    //MARK:- AVCaptureMetadataOutputObjectsDelegate
    // 该代理代理方法，会频繁的扫描
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        playSoundEffect(name: "sound.caf")
        session.stopRunning()
        qrCodeView.stopScanAnimation()
        previewLayer.removeFromSuperlayer()
        if metadataObjects.count > 0 {
            let obj : AVMetadataMachineReadableCodeObject = metadataObjects.first as! AVMetadataMachineReadableCodeObject
            scanUrl(urlString: obj.stringValue! as String)
        }
    }
        
    //MARK:- UIImagePickerControllerDelegate
    /// 从相册中识别二维码, 并进行界面跳转
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            self.scanQRCodeFromPhotosInTheAlbum(image: info[UIImagePickerController.InfoKey.originalImage] as! UIImage)
        }
    }
}

