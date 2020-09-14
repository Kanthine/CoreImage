//
//  ScanQRCodeView.swift
//  CoreImage-Swift
//
//  Created by 苏沫离 on 2017/9/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

import UIKit

class ScanQRCodeView: UIView {

    /// 扫描框的坐标
    var scanRect : CGRect!
        
    ///懒加载
    lazy var gradientLayer : CAGradientLayer = {
        let gLayer = CAGradientLayer()
        gLayer.colors = [UIColor(red: 141.0 / 255, green: 31.0 / 255, blue: 203.0 / 255, alpha: 0.8).cgColor,
                         UIColor(red: 141.0 / 255, green: 31.0 / 255, blue: 203.0 / 255, alpha: 1.0).cgColor,
                         UIColor(red: 141.0 / 255, green: 31.0 / 255, blue: 203.0 / 255, alpha: 0.8).cgColor,]
        gLayer.locations = [0.25, 0.75, 1.0]
        gLayer.startPoint = CGPoint.zero
        gLayer.endPoint = CGPoint(x: 0, y: 1)
        gLayer.frame = CGRect(x: scanRect.origin.x + 5, y: scanRect.origin.y, width: scanRect.width - 10, height: 2)
        return gLayer
    }()
    
    convenience init(frame: CGRect,scanRect: CGRect) {
        self.init(frame: frame)
        backgroundColor = UIColor.clear
        self.scanRect = scanRect
        
        let imageView = UIImageView(frame: scanRect)
        imageView.image = UIImage(named: "navBar_BarBack")
        addSubview(imageView)
        
        let lable = UILabel(frame: CGRect(x: 0, y: scanRect.maxY + 10, width: frame.width, height: 20))
        lable.text = "放入框内，自动扫描"
        lable.textAlignment = .center
        lable.textColor = UIColor.white
        lable.font = UIFont.systemFont(ofSize: 15)
        addSubview(lable)

        let bottomLable = UILabel(frame: CGRect(x: 0, y: frame.height - 40, width: frame.width, height: 20))
        bottomLable.text = "扫码"
        bottomLable.textAlignment = .center
        bottomLable.textColor = UIColor.white
        bottomLable.font = UIFont.systemFont(ofSize: 15)
        addSubview(bottomLable)
        
        let bottomImageView = UIImageView(frame: CGRect(x: frame.width / 2.0 - 16, y: frame.height - 80, width: 32, height: 32))
        bottomImageView.image = UIImage(named: "navBar_BarScan")
        addSubview(bottomImageView)

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        context?.fill(bounds)
        context?.setStrokeColor(UIColor(red: 141.0 / 255, green: 31.0 / 255, blue: 203.0 / 255, alpha: 1.0).cgColor)
        context?.stroke(scanRect, width: 2)
        context?.clear(scanRect)
    }
    
    func startScanAnimation() {
        layer.addSublayer(gradientLayer)
        let startPoint = CGPoint(x: frame.width / 2.0, y: scanRect.origin.y + 3)
        let endPoint = CGPoint(x: frame.width / 2.0, y: scanRect.maxY - 6)
        let scanNetAnimation = CABasicAnimation(keyPath: "position")
        scanNetAnimation.fromValue = NSValue.init(cgPoint: startPoint)
        scanNetAnimation.toValue = NSValue.init(cgPoint: endPoint)
        scanNetAnimation.duration = 2.0
        scanNetAnimation.repeatCount = MAXFLOAT
        self.gradientLayer.add(scanNetAnimation, forKey: "scanNetAnimation")
    }
    
    func stopScanAnimation() {
        gradientLayer.removeAnimation(forKey: "scanNetAnimation")
        gradientLayer.removeFromSuperlayer()
    }
}
