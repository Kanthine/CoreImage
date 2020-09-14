//
//  ScanQRCodeView.h
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ScanQRCodeView : UIView

/// 扫描框的坐标
@property (nonatomic ,assign) CGRect scanRect;

- (instancetype)initWithFrame:(CGRect)frame scanRect:(CGRect)scanRect;

- (void)startScanAnimation;

- (void)stopScanAnimation;

@end

NS_ASSUME_NONNULL_END
