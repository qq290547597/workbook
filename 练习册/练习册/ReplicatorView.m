//
//  ReplicatorView.m
//  练习册
//
//  Created by lixinjie on 2018/2/26.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  复制图层的使用

#import "ReplicatorView.h"

@implementation ReplicatorView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addMusicView];
        [self addActivityIndicatorView];
        [self addReflectionView];
    }
    return self;
}

/**
 音乐震动条
 */
- (void)addMusicView {
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(self.bounds.size.width / 2 - 250 / 2, 100, 250, 100)];
    bgv.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgv];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgv.frame.origin.x - 30, bgv.frame.origin.y - 15, 30, bgv.frame.size.height + 30)];
    textLabel.text = @"音\n乐\n震\n动\n条";
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    
    //CAReplicatorLayer复制图层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = bgv.bounds;
    [bgv.layer addSublayer:replicatorLayer];
    
    CALayer *layer = [CALayer layer];
    layer.anchorPoint = CGPointMake(0.5, 1);
    layer.position = CGPointMake(30, bgv.bounds.size.height);
    layer.bounds = CGRectMake(0, 0, 30, bgv.bounds.size.height - 20);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [replicatorLayer addSublayer:layer];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale.y";
    animation.toValue = @0.1;
    animation.duration = 0.5;
    animation.repeatCount = MAXFLOAT;
    animation.autoreverses = YES;
    [layer addAnimation:animation forKey:nil];
    
    //设置子视图的总数量
    replicatorLayer.instanceCount = 5;
    //设置子视图间的偏移量
    replicatorLayer.instanceTransform = CATransform3DMakeTranslation(45, 0, 0);
    //设置子视图动画延迟时间
    replicatorLayer.instanceDelay = 0.1;
    //设置子视图颜色
    replicatorLayer.instanceColor = [UIColor redColor].CGColor;
    //设置子视图间的颜色变化
    replicatorLayer.instanceRedOffset = -0.2;
}

/**
 模拟活动指示器
 */
- (void)addActivityIndicatorView {
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 250) / 2, 220, 250, 100)];
    bgv.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgv];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgv.frame.origin.x - 30, bgv.frame.origin.y - 15, 30, bgv.frame.size.height + 30)];
    textLabel.text = @"活\n动\n指\n示\n器";
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    
    //CAReplicatorLayer复制图层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = bgv.bounds;
    [bgv.layer addSublayer:replicatorLayer];
    
    CALayer *layer = [CALayer layer];
    layer.transform = CATransform3DMakeScale(0, 0, 0);//先设置不可见
    layer.position = CGPointMake(bgv.bounds.size.width / 2, 20);
    layer.bounds = CGRectMake(0, 0, 10, 10);
    layer.cornerRadius = 5;
    layer.backgroundColor = [UIColor redColor].CGColor;
    [replicatorLayer addSublayer:layer];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.scale";
    animation.fromValue = @1;
    animation.toValue = @0;
    animation.duration = 1;
    animation.repeatCount = MAXFLOAT;
    [layer addAnimation:animation forKey:nil];
    
    //设置子视图的总数量
    replicatorLayer.instanceCount = 20;
    //设置子视图间的偏移量
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(2 * M_PI / replicatorLayer.instanceCount, 0, 0, 1);
    //设置子视图动画延迟时间
    replicatorLayer.instanceDelay = animation.duration / replicatorLayer.instanceCount;
}

/**
 倒影
 */
- (void)addReflectionView {
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake((self.bounds.size.width - 250) / 2, 340, 250, 177)];
    bgv.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgv];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgv.frame.origin.x - 30, bgv.frame.origin.y, 30, bgv.frame.size.height)];
    textLabel.text = @"倒\n影";
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor blackColor];
    textLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:textLabel];
    
    //CAReplicatorLayer复制图层
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = bgv.bounds;
    [bgv.layer addSublayer:replicatorLayer];
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake((replicatorLayer.bounds.size.width - 125) / 2, 0, 125, 88.5);
    layer.contents = (id)[UIImage imageNamed:@"image3"].CGImage;
    [replicatorLayer addSublayer:layer];
    
    //设置子视图的总数量
    replicatorLayer.instanceCount = 2;
    //设置子视图间的偏移量
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    replicatorLayer.instanceRedOffset = replicatorLayer.instanceGreenOffset = replicatorLayer.instanceBlueOffset = -0.3;
    
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
