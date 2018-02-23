//
//  WatermarkView.m
//  练习册
//
//  Created by lixinjie on 2018/1/4.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  图片水印

#import "WatermarkView.h"

@interface WatermarkView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation WatermarkView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addImageView];
        [self addButton];
    }
    return self;
}

- (void)addImageView {
    UIImage *image = [UIImage imageNamed:@"image1"];
    image = [UIImage imageWithCGImage:image.CGImage scale:image.size.width / self.bounds.size.width orientation:0];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = self.center;
    [self addSubview:imageView];
    self.imageView = imageView;
}

- (void)addButton {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.bounds = CGRectMake(0, 0, 80, 44);
    button.center = CGPointMake(self.imageView.center.x, self.imageView.center.y + self.imageView.bounds.size.height / 2 + 30);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitle:@"加水印" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addWatermark:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)addWatermark:(UIButton *)button {
    UIImage *image = self.imageView.image;
    //获取图片上下文,参数opaque,NO为不透明 scale,0为不缩放
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //绘制原生图片
    [image drawAtPoint:CGPointZero];
    //添加水印
    [@"我是水印" drawAtPoint:CGPointMake(image.size.width - 70, image.size.height - 23) withAttributes:@{NSForegroundColorAttributeName : [UIColor redColor], NSFontAttributeName : [UIFont systemFontOfSize:16], NSBackgroundColorAttributeName : [UIColor lightGrayColor]}];
    //生成水印图片
    UIImage *waterImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    self.imageView.image = waterImage;
    
    [button removeFromSuperview];
    button = nil;
}

@end
