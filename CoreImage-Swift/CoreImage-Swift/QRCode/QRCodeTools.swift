//
//  QRCodeTools.swift
//  CoreImage-Swift
//
//  Created by 苏沫离 on 2017/9/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

import UIKit

//+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
//    CGRect extent = CGRectIntegral(image.extent);
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//
//    // 1.创建bitmap;
//    size_t width = CGRectGetWidth(extent) * scale;
//    size_t height = CGRectGetHeight(extent) * scale;
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//
//    // 2.保存bitmap到图片
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    CGContextRelease(bitmapRef);
//    CGImageRelease(bitmapImage);
//    return [UIImage imageWithCGImage:scaledImage];
//}

extension UIImage {
        @objc class func createNonInterpolatedUIImageFormCIImage(image:CIImage, size:CGFloat) ->UIImage {
    //        CGRect.i
    //        let extent : CGRect = CGRect.intersection(image.extent)
    //
    //        let scale = min(size / extent.width, <#T##y: Comparable##Comparable#>)
    //
    //        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            
            return UIImage()
        }

}


class QRCodeTools: NSObject {

    /** 创建二维码
    *  @param dataString 二维码的数据信息
    */
    @objc class func creatQRCode(dataString:String) ->CIImage {
        let data = dataString.data(using: .utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setDefaults()
        filter?.setValue(data, forKey: "inputMessage")
        let outputImage : CIImage = (filter?.outputImage)!
        return outputImage
    }
    
    /** 生成一张普通的二维码
    *  @param dataString 二维码的数据信息
    */
    @objc class func creatNormalQRCode(dataString:String) ->UIImage {
        let outputImage : CIImage = creatQRCode(dataString: dataString)
        //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
        let barcodeImage = UIImage.createNonInterpolatedUIImageFormCIImage(image: outputImage, size: 300)
        return barcodeImage
    }
    
    /** 生成一张带有logo的二维码
    *  @param logoScaleToSuperView    logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
    */
    @objc class func creatLogoQRCode(dataString:String, logoImage:UIImage ,logoScaleToSuperView : CGFloat) ->UIImage {
        var outputImage : CIImage = creatQRCode(dataString: dataString)
        outputImage = outputImage.transformed(by: CGAffineTransform(scaleX: 20, y: 20))
        
        let start_image = UIImage(ciImage: outputImage)
        UIGraphicsBeginImageContext(start_image.size)
        start_image.draw(in: CGRect(origin: CGPoint.zero, size: start_image.size))
        let icon_imageW = start_image.size.width * logoScaleToSuperView
        let icon_imageH = start_image.size.height * logoScaleToSuperView
        let icon_imageX = (start_image.size.width - icon_imageW) * 0.5
        let icon_imageY = (start_image.size.height - icon_imageH) * 0.5
        logoImage.draw(in: CGRect(x: icon_imageX, y: icon_imageY, width: icon_imageW, height: icon_imageH))
        
        let final_image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return final_image!
    }
    
    /** 生成一张彩色的二维码
    *  @param backgroundColor 背景色
    *  @param mainColor 主颜色
    */
    @objc class func creatColoursQRCode(dataString:String, backgroundColor:CIColor ,mainColor:CIColor) ->UIImage {
        var outputImage : CIImage = creatQRCode(dataString: dataString)
        outputImage = outputImage.transformed(by: CGAffineTransform(scaleX: 9, y: 9))
        
        let color_filter = CIFilter(name: "CIFalseColor")
        color_filter?.setDefaults()
        color_filter?.setValue(outputImage, forKey: "inputMessage")
        color_filter?.setValue(backgroundColor, forKey: "inputColor0")
        color_filter?.setValue(mainColor, forKey: "inputColor1")
        return UIImage(ciImage: (color_filter?.outputImage)!)
    }
}

