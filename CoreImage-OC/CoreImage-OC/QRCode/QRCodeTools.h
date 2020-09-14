//
//  QRCodeTools.h
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCodeTools : NSObject

/** 生成一张普通的二维码
 *  @param dataString 二维码的数据信息
 */
+ (UIImage *)creatNormalScanLifeWithDataString:(NSString *)dataString;

/** 生成一张带有logo的二维码
 *  @param dataString 二维码的数据信息
 *  @param scale logo相对于父视图的缩放比（取值范围：0-1，0，代表不显示，1，代表与父视图大小相同）
 */
+ (UIImage *)creatLogoQRCodeWithData:(NSString *)dataString logo:(UIImage *)image logoToSuperScale:(CGFloat)scale;

/** 生成一张彩色的二维码
 *  @param backgroundColor 背景色
 *  @param mainColor 主颜色
 */
+ (UIImage *)creatColoursQRCodeWithData:(NSString *)dataString backgroundColor:(CIColor *)backgroundColor mainColor:(CIColor *)mainColor;


@end

NS_ASSUME_NONNULL_END
