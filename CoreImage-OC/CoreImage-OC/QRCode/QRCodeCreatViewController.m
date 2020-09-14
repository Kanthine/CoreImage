//
//  QRCodeCreatViewController.m
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import "QRCodeCreatViewController.h"
#import "QRCodeTools.h"

@interface QRCodeCreatViewController ()

@property (nonatomic ,strong) UITextView *textView;
@property (nonatomic ,strong) UIImageView *qrCodeImageView;
@property (nonatomic ,strong) UIButton *creatButton;

@end

@implementation QRCodeCreatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.whiteColor;
    [self.view addSubview:self.textView];
    [self.view addSubview:self.creatButton];
    [self.view addSubview:self.qrCodeImageView];
}

#pragma mark - response click

- (void)creatButtonClick:(UIButton *)sender{
    self.qrCodeImageView.image = [QRCodeTools creatLogoQRCodeWithData:self.textView.text logo:[UIImage imageNamed:@"header"] logoToSuperScale:0.25];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - setters and getters

- (UIButton *)creatButton{
    if (_creatButton == nil) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(120, CGRectGetMaxY(self.textView.frame) + 20, 100, 38);

        CAGradientLayer *gl = [CAGradientLayer layer];
        gl.backgroundColor = [UIColor colorWithRed:72/255.0 green:147/255.0 blue:247/255.0 alpha:1.0].CGColor;
        gl.cornerRadius = 6;
        gl.frame = button.bounds;
        gl.startPoint = CGPointMake(0, 0);
        gl.endPoint = CGPointMake(1, 1);
        gl.colors = @[(__bridge id)[UIColor colorWithRed:26/255.0 green:67/255.0 blue:255/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:19/255.0 green:134/255.0 blue:255/255.0 alpha:1.0].CGColor];
        gl.locations = @[@(0.0),@(1.0)];
        [button.layer addSublayer:gl];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
        [button setTitle:@"创建二维码" forState:UIControlStateNormal];

        [button addTarget:self action:@selector(creatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _creatButton = button;
    }
    return _creatButton;
}

- (UITextView *)textView{
    if (_textView == nil) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 20, CGRectGetWidth(UIScreen.mainScreen.bounds) - 40, 80)];
        _textView.backgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        _textView.bounces = NO;
        _textView.showsVerticalScrollIndicator = NO;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.textColor = UIColor.blackColor;
        _textView.text = @"请输入二维码信息";
    }
    return _textView;
}

- (UIImageView *)qrCodeImageView{
    if (_qrCodeImageView == nil) {
        _qrCodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake( (CGRectGetWidth(UIScreen.mainScreen.bounds) - 260) / 2.0,CGRectGetMaxY(self.creatButton.frame) + 60, 260, 260)];
    }
    return _qrCodeImageView;
}

@end
