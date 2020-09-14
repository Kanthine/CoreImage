//
//  ScanQRCodeView.m
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import "ScanQRCodeView.h"

@interface ScanQRCodeView()
@property (nonatomic ,strong) CAGradientLayer *gradientLayer;
@end

@implementation ScanQRCodeView

- (instancetype)initWithFrame:(CGRect)frame scanRect:(CGRect)scanRect{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = UIColor.clearColor;
        self.scanRect = scanRect;
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:scanRect];
        imageView.image = [UIImage imageNamed:@"navBar_BarBack"];
        [self addSubview:imageView];
        
        UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(scanRect) + 10, CGRectGetWidth(frame), 20)];
        lable.text = @"放入框内，自动扫描";
        lable.textAlignment = NSTextAlignmentCenter;
        lable.textColor = [UIColor whiteColor];
        lable.font = [UIFont systemFontOfSize:15];
        [self addSubview:lable];
        
        UILabel *bottomLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(frame) - 40, CGRectGetWidth(frame), 20)];
        bottomLable.text = @"扫码";
        bottomLable.textAlignment = NSTextAlignmentCenter;
        bottomLable.textColor = [UIColor whiteColor];
        bottomLable.font = [UIFont systemFontOfSize:15];
        [self addSubview:bottomLable];

        UIImageView *bottomImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetWidth(frame) / 2.0 - 16, CGRectGetHeight(frame) - 80, 32, 32)];
        bottomImageView.image = [UIImage imageNamed:@"navBar_BarScan"];
        [self addSubview:bottomImageView];
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIColor *borderColor = [UIColor colorWithRed:141.0 / 255 green:31.0/ 255 blue:203.0/ 255 alpha:1.0];
    //填充颜色和模式
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetRGBFillColor(ctx, 0, 0, 0, 0.6);
    CGContextFillRect(ctx, self.bounds);
    CGContextSetStrokeColorWithColor(ctx, borderColor.CGColor);
    CGContextStrokeRectWithWidth(ctx, self.scanRect, 2);
    CGContextClearRect(ctx, self.scanRect);
}

/*
 CGContextClearRect函数的功能是擦除一个区域。这个函数会擦除一个矩形内的所有已存在的绘图；并对该区域执行裁剪。结果像是打了一个贯穿所有已存在绘图的孔。
 
 CGContextClearRect函数的行为依赖于上下文是透明还是不透明。当在图形上下文中绘图时，这会尤为明显和直观。如果图片上下文是透明的（UIGraphicsBeginImageContextWithOptions第二个参数为NO），那么CGContextClearRect函数执行擦除后的颜色为透明，反之则为黑色。
 
 当在一个视图中直接绘图（使用drawRect：或drawLayer：inContext：方法），如果视图的背景颜色为nil或颜色哪怕有一点点透明度，那么CGContextClearRect的矩形区域将会显示为透明的，打出的孔将穿过视图包括它的背景颜色。如果背景颜色完全不透明，那么CGContextClearRect函数的结果将会是黑色。这是因为视图的背景颜色决定了是否视图的图形上下文是透明的还是不透明的。
 */


#pragma mark - public method

- (void)startScanAnimation{
    [self.layer addSublayer:self.gradientLayer];

    CGPoint startPoint = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, self.scanRect.origin.y + 3);
    CGPoint endPoint = CGPointMake(CGRectGetWidth(UIScreen.mainScreen.bounds) / 2.0, CGRectGetMaxY(self.scanRect) - 6);
        
    CABasicAnimation *scanNetAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    scanNetAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    scanNetAnimation.toValue = [NSValue valueWithCGPoint:endPoint];
    scanNetAnimation.duration = 2.0;
    scanNetAnimation.repeatCount = MAXFLOAT;
    [self.gradientLayer addAnimation:scanNetAnimation forKey:@"scanNetAnimation"];
}

- (void)stopScanAnimation{
    [self.gradientLayer removeAnimationForKey:@"scanNetAnimation"];
    [self.gradientLayer removeFromSuperlayer];
    _gradientLayer = nil;
}

#pragma mark - setters and getters

- (CAGradientLayer *)gradientLayer{
    if (_gradientLayer == nil){
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        
        gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:141.0 / 255 green:31.0/ 255 blue:203.0/ 255 alpha:0.8].CGColor,
                                 (__bridge id)[UIColor colorWithRed:141.0 / 255 green:31.0/ 255 blue:203.0/ 255 alpha:1.0].CGColor,
                                 (__bridge id)[UIColor colorWithRed:141.0 / 255 green:31.0/ 255 blue:203.0/ 255 alpha:0.8].CGColor];
        gradientLayer.locations = @[@0.25, @0.75, @1.0];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1.0);
        gradientLayer.frame = CGRectMake(self.scanRect.origin.x + 5, self.scanRect.origin.y, CGRectGetWidth(self.scanRect) - 10, 2);
        
        
        _gradientLayer = gradientLayer;
    }
    return _gradientLayer;
}

@end
