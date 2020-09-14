//
//  ScanQRCodeViewController.h
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol ScanQRCodeViewControllerDelegate <NSObject>
@required
- (void)scanResult:(NSString *)result error:(NSString *)error;
@end

///二维码扫描器
@interface ScanQRCodeViewController : UIViewController

@property (nonatomic ,weak) id <ScanQRCodeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
