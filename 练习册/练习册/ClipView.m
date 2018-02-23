//
//  ClipView.m
//  练习册
//
//  Created by lixinjie on 2018/1/4.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  图片裁剪

#import "ClipView.h"

@interface ClipView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ClipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
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
    [button setTitle:@"裁剪" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clip:)  forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
}

- (void)clip:(UIButton *)button {
    UIImage *image = self.imageView.image;
    //获取图片上下文,参数opaque,NO为不透明 scale,0为不缩放
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    [path addClip];
    
    //绘制图片
    [image drawAtPoint:CGPointZero];
    //生成水印图片
    UIImage *clipImage = UIGraphicsGetImageFromCurrentImageContext();
    //关闭上下文
    UIGraphicsEndImageContext();
    
    self.imageView.image = clipImage;
    
    [button removeFromSuperview];
    button = nil;
}

@end
