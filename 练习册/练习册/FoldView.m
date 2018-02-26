//
//  FoldView.m
//  练习册
//
//  Created by lixinjie on 2018/2/23.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  折叠图片

#import "FoldView.h"

@interface FoldView ()

@property (nonatomic, strong) UIImageView *topView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation FoldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView {
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 177)];
    bgv.center = self.center;
    [self addSubview:bgv];
    
    UIImage *image = [UIImage imageNamed:@"image3"];
    
    UIImageView *topView = [[UIImageView alloc] initWithImage:image];
    topView.layer.anchorPoint = CGPointMake(0.5, 1);
    topView.frame = CGRectMake(0, 0, bgv.bounds.size.width, bgv.bounds.size.height / 2);
    topView.layer.contentsRect = CGRectMake(0, 0, 1, 0.5);//设置内容只显示上半部分
    
    UIImageView *bottomView = [[UIImageView alloc] initWithImage:image];
    bottomView.frame = CGRectMake(0, CGRectGetMaxY(topView.frame), bgv.bounds.size.width, bgv.bounds.size.height / 2);
    bottomView.layer.contentsRect = CGRectMake(0, 0.5, 1, 0.5);//设置内容只显示下半部分
    [bgv addSubview:bottomView];
    [bgv addSubview:topView];
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [bgv addGestureRecognizer:pan];
    
    //渐变图层
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = bottomView.bounds;
    gradientLayer.opacity = 0;
    gradientLayer.colors = @[(id)[UIColor clearColor].CGColor, (id)[UIColor blackColor].CGColor];
    [bottomView.layer addSublayer:gradientLayer];
    
    self.topView = topView;
    self.gradientLayer = gradientLayer;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    //获取偏移量
    CGPoint translationPoint = [pan translationInView:pan.view];
    //获取最大偏移量
    CGFloat maxOffsetY = pan.view.bounds.size.height;
    
    if (translationPoint.y > -maxOffsetY && translationPoint.y <= maxOffsetY) {
        CGFloat angle = -translationPoint.y / maxOffsetY * M_PI;
        
        CATransform3D transfrom = CATransform3DIdentity;
        //增加旋转的立体感
        transfrom.m34 = -1 / 400.0;
        transfrom = CATransform3DRotate(transfrom, angle, 1, 0, 0);
        
        self.topView.layer.transform = transfrom;
        
        self.gradientLayer.opacity = translationPoint.y / maxOffsetY;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //反弹动画
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.topView.layer.transform = CATransform3DIdentity;
            self.gradientLayer.opacity = 0;
        } completion:nil];
    }
}


- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
