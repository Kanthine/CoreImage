//
//  QRCodeTools.m
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import "QRCodeTools.h"
#import <CoreImage/CoreImage.h>

@interface UIImage (CIImage)

@end

@implementation UIImage (CIImage)

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}


@end


@implementation QRCodeTools

/** 生成二维码
 */
+ (CIImage *)creatScanLifeWithDataString:(NSString *)dataString{
    NSData *data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    // 1.创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2.恢复默认
    [filter setDefaults];
    // 3.给过滤器添加数据(正则表达式/账号和密码)
    [filter setValue:data forKeyPath:@"inputMessage"];
    return [filter outputImage];
}

/** 生成一张普通的二维码
 *  @param dataString 二维码的数据信息
 */
+ (UIImage *)creatNormalScanLifeWithDataString:(NSString *)dataString{
    CIImage *outputImage = [QRCodeTools creatScanLifeWithDataString:dataString];
    //因为生成的二维码模糊，所以通过createNonInterpolatedUIImageFormCIImage:outputImage来获得高清的二维码图片
    UIImage *barcodeImage = [UIImage createNonInterpolatedUIImageFormCIImage:outputImage withSize:300];
    return barcodeImage;
}


/** 生成一张带有logo的二维码
 *  @param dataString 二维码的数据信息
 *  @param scale logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)creatLogoQRCodeWithData:(NSString *)dataString logo:(UIImage *)image logoToSuperScale:(CGFloat)scale{
    CIImage *outputImage = [QRCodeTools creatScanLifeWithDataString:dataString];
    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(20, 20)];
    // 4、将CIImage类型转成UIImage类型
    UIImage *start_image = [UIImage imageWithCIImage:outputImage];
    // - - - - - - - - - - - - - - - - 添加中间小图标 - - - - - - - - - - - - - - - -
    // 5、开启绘图, 获取图形上下文 (上下文的大小, 就是二维码的大小)
    UIGraphicsBeginImageContext(start_image.size);
    // 把二维码图片画上去 (这里是以图形上下文, 左上角为(0,0)点
    [start_image drawInRect:CGRectMake(0, 0, start_image.size.width, start_image.size.height)];
    // 再把小图片画上去
    CGFloat icon_imageW = start_image.size.width * scale;
    CGFloat icon_imageH = start_image.size.height * scale;
    CGFloat icon_imageX = (start_image.size.width - icon_imageW) * 0.5;
    CGFloat icon_imageY = (start_image.size.height - icon_imageH) * 0.5;
    [image drawInRect:CGRectMake(icon_imageX, icon_imageY, icon_imageW, icon_imageH)];
    // 6、获取当前画得的这张图片
    UIImage *final_image = UIGraphicsGetImageFromCurrentImageContext();
    // 7、关闭图形上下文
    UIGraphicsEndImageContext();
    return final_image;
}

/** 生成一张彩色的二维码
 *  @param backgroundColor 背景色
 *  @param mainColor 主颜色
 */
+ (UIImage *)creatColoursQRCodeWithData:(NSString *)dataString backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor{
    CIImage *outputImage = [QRCodeTools creatScanLifeWithDataString:dataString];

    // 图片小于(27,27),我们需要放大
    outputImage = [outputImage imageByApplyingTransform:CGAffineTransformMakeScale(9, 9)];
    // 4、创建彩色过滤器(彩色的用的不多)
    CIFilter * color_filter = [CIFilter filterWithName:@"CIFalseColor"];
    // 设置默认值
    [color_filter setDefaults];
    // 5、KVC 给私有属性赋值
    [color_filter setValue:outputImage forKey:@"inputImage"];
    // 6、需要使用 CIColor
    [color_filter setValue:backgroundColor forKey:@"inputColor0"];
    [color_filter setValue:mainColor forKey:@"inputColor1"];
    // 7、设置输出
    CIImage *colorImage = [color_filter outputImage];
    return [UIImage imageWithCIImage:colorImage];
}

@end
