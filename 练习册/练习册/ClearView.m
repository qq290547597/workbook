//
//  ClearView.m
//  练习册
//
//  Created by lixinjie on 2018/1/4.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  图片擦除

#import "ClearView.h"

@interface ClearView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ClearView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addImageView];
    }
    return self;
}

- (void)addImageView {
    UIImage *image = [UIImage imageNamed:@"image1"];
    image = [UIImage imageWithCGImage:image.CGImage scale:image.size.width / self.bounds.size.width orientation:0];
    
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"image2"]];
    imageView2.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView2.center = self.center;
    [self addSubview:imageView2];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    imageView.center = self.center;
    [self addSubview:imageView];
    self.imageView = imageView;
    imageView.userInteractionEnabled = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [imageView addGestureRecognizer:pan];
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    //获取当前触摸点
    CGPoint currentPoint = [pan locationInView:self.imageView];
    
    CGFloat w = 20;
    CGFloat x = currentPoint.x - w * 0.5;
    CGFloat y = currentPoint.y - w * 0.5;
    
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:ctx];
    
    CGContextClearRect(ctx, CGRectMake(x, y, w, w));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    self.imageView.image = image;
    
    UIGraphicsEndImageContext();
}
@end
