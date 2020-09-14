//
//  QRCodeCreatViewController.swift
//  CoreImage-Swift
//
//  Created by 苏沫离 on 2017/9/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//
// 创建二维码

import UIKit

class QRCodeCreatViewController: UIViewController {
    lazy var textView : UITextView = {
        let textV = UITextView(frame: CGRect(x: 20, y: 20, width: view.bounds.width - 40, height: 80))
        textV.backgroundColor = UIColor(red: 232/255.0, green: 232/255.0, blue: 232/255.0, alpha: 1.0)
        textV.bounces = false
        textV.showsVerticalScrollIndicator = false
        textV.font = UIFont.systemFont(ofSize: 15)
        textV.textColor = UIColor.black
        textV.text = "请输入二维码信息"
        return textV
    }()
    
    lazy var creatButton : UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 120, y: textView.frame.maxY + 20, width: 100, height: 38)
        
        let gl = CAGradientLayer()
        gl.backgroundColor = UIColor(red: 72/255.0, green: 147/255.0, blue: 247/255.0, alpha: 1.0).cgColor
        gl.cornerRadius = 6
        gl.frame = button.bounds
        gl.startPoint = CGPoint.zero
        gl.endPoint = CGPoint(x: 1, y: 1)
        gl.colors = [UIColor(red: 26/255.0, green: 67/255.0, blue: 255/255.0, alpha: 1.0).cgColor,
                     UIColor(red: 19/255.0, green: 134/255.0, blue: 255/255.0, alpha: 1.0).cgColor,]
        gl.locations = [0.0,1.0];
        button.layer.addSublayer(gl)
            
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("创建二维码", for: .normal)
        button.addTarget(self, action: #selector(creatButtonClick(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var qrCodeImageView : UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: (view.bounds.width - 260) / 2.0, y: creatButton.frame.maxY + 60, width: 260, height: 260))
        return imageView
    }()
    
    // MARK: - life cycyle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        self.view.addSubview(textView)
        self.view.addSubview(creatButton)
        self.view.addSubview(qrCodeImageView)
    }
    
    // MARK: - response click
    @objc func creatButtonClick(sender : UIButton) {
        qrCodeImageView.image = QRCodeTools.creatLogoQRCode(dataString: textView.text, logoImage: UIImage(named: "header")!, logoScaleToSuperView: 0.25)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
