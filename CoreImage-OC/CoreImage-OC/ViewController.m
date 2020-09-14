//
//  ViewController.m
//  CoreImage
//
//  Created by 苏沫离 on 2017/2/14.
//  Copyright © 2017 苏沫离. All rights reserved.
//

#import "ViewController.h"
#import "ScanQRCodeViewController.h"
#import "QRCodeCreatViewController.h"

@interface ViewController ()
<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) NSMutableArray<NSString *> *dataArray;
@property (nonatomic ,strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title = @"CoreImage";
    [self.view addSubview:self.tableView];
}

- (void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *item = self.dataArray[indexPath.row];
    if ([item isEqualToString:@"扫描二维码"]) {
        ScanQRCodeViewController *scanQRCodeVC = [[ScanQRCodeViewController alloc] init];
        scanQRCodeVC.navigationItem.title = item;
        [self.navigationController pushViewController:scanQRCodeVC animated:YES];
    }else if ([item isEqualToString:@"创建二维码"]){
        QRCodeCreatViewController *creatQRCodeVC = [[QRCodeCreatViewController alloc] init];
        creatQRCodeVC.navigationItem.title = item;
        [self.navigationController pushViewController:creatQRCodeVC animated:YES];
    }
}

#pragma mark - setter and getters

-(NSMutableArray<NSString *> *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
        [_dataArray addObject:@"扫描二维码"];
        [_dataArray addObject:@"创建二维码"];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    if (_tableView == nil){
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(UIScreen.mainScreen.bounds),CGRectGetHeight(UIScreen.mainScreen.bounds)) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor colorWithRed:250/255.0 green:250/255.0 blue:250/255.0 alpha:1.0];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.tableFooterView = UIView.new;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.separatorColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1.0];
        tableView.rowHeight = 45;
        tableView.sectionFooterHeight = 0.1f;
        [tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"UITableViewCell"];
        _tableView = tableView;
    }
    return _tableView;
}

@end
