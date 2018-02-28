//
//  ViewController.m
//  练习册
//
//  Created by lixinjie on 2018/1/3.
//  Copyright © 2018年 lixinjie. All rights reserved.
//

#import "ViewController.h"
#import "Header.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"练习册";
    
    self.dataArr = @[@[@"手势解锁", [LockView class]],
                     @[@"图片水印", [WatermarkView class]],
                     @[@"图片裁剪", [ClipView class]],
                     @[@"图片擦除", [ClearView class]],
                     @[@"时钟", [ClockView class]],
                     @[@"折叠图片", [FoldView class]],
                     @[@"复制layer的使用", [ReplicatorView class]],
                     @[@"仿QQ未读红点", [QQRedDotView class]],
                     ];
    
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
    
    cell.textLabel.text = self.dataArr[indexPath.row][0];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIViewController *vc = [[UIViewController alloc] init];
    vc.title = self.dataArr[indexPath.row][0];
    [vc.view addSubview:[[self.dataArr[indexPath.row][1] alloc] initWithFrame:vc.view.bounds]];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
