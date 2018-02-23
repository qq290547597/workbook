//
//  ViewController.m
//  练习册
//
//  Created by lixinjie on 2018/1/3.
//  Copyright © 2018年 lixinjie. All rights reserved.
//

#import "ViewController.h"
#import "LockView.h"
#import "WatermarkView.h"
#import "ClipView.h"
#import "ClearView.h"
#import "ClockView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"练习册";
    
    self.dataArr = @[@"手势解锁", @"图片水印", @"图片裁剪", @"图片擦除", @"时钟"];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.textLabel.text = self.dataArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = self.dataArr[indexPath.row];
    if ([vc.title isEqualToString:@"手势解锁"]) {
        LockView *lockView = [[LockView alloc] initWithFrame:vc.view.bounds];
        [vc.view addSubview:lockView];
    } else if ([vc.title isEqualToString:@"图片水印"]) {
        WatermarkView *watermarkView = [[WatermarkView alloc] initWithFrame:vc.view.bounds];
        [vc.view addSubview:watermarkView];
    } else if ([vc.title isEqualToString:@"图片裁剪"]) {
        ClipView *clipView = [[ClipView alloc] initWithFrame:vc.view.bounds];
        [vc.view addSubview:clipView];
    } else if ([vc.title isEqualToString:@"图片擦除"]) {
        ClearView *clearView = [[ClearView alloc] initWithFrame:vc.view.bounds];
        [vc.view addSubview:clearView];
    } else if ([vc.title isEqualToString:@"时钟"]) {
        ClockView *clockView = [[ClockView alloc] initWithFrame:vc.view.bounds];
        [vc.view addSubview:clockView];
    }
    
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
