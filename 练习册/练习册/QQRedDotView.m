//
//  QQRedDotView.m
//  练习册
//
//  Created by lixinjie on 2018/2/27.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  仿QQ未读红点

#import "QQRedDotView.h"

@interface RedDotLabel : UILabel

@property (nonatomic, strong) UIView *samllCircleView;/**< 小圆圈 */
@property (nonatomic, assign) CGFloat maxDistance;/**< 拖拽的最大距离 */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;/**< 不规则图形 */
@property (nonatomic, copy) void (^destroyRedDotBlock) (void);/**< 销毁红点block */

@end

@implementation QQRedDotView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView {
    UIView *bgv = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    bgv.center = self.center;
    bgv.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bgv];
    
    RedDotLabel *redDotLabel = [[RedDotLabel alloc] initWithFrame:CGRectMake(bgv.bounds.size.width - 50, 0, 50, 50)];
    [bgv addSubview:redDotLabel];
    __weak typeof(self) weakSelf = self;
    redDotLabel.destroyRedDotBlock = ^{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"点我显示红点" forState:UIControlStateNormal];
        button.frame = CGRectMake(bgv.frame.origin.x, CGRectGetMaxY(bgv.frame) + 5, bgv.frame.size.width, 60);
        button.backgroundColor = bgv.backgroundColor;
        [button addTarget:weakSelf action:@selector(showRedDot:) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf addSubview:button];
    };
}

- (void)showRedDot:(UIButton *)button {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [self addView];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end


@implementation RedDotLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor redColor];
        CGFloat cornerRadius = MIN(frame.size.height, frame.size.width) * 0.5;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = cornerRadius;
        
        self.maxDistance = cornerRadius * 4;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    [self.layer removeAllAnimations];
    
    CGPoint panPoint = [pan translationInView:self];
    CGPoint offsetCenter = CGPointMake(self.center.x + panPoint.x, self.center.y + panPoint.y);
    CGFloat distance = [self centerDistanceWithPointA:offsetCenter potintB:self.samllCircleView.center];
    self.center = offsetCenter;
    [pan setTranslation:CGPointZero inView:self];
    
    if (distance > self.maxDistance) {
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
        self.samllCircleView.hidden = YES;
    } else if (self.samllCircleView.hidden == NO) {
        CGFloat cornerRadius = self.layer.cornerRadius;
        CGFloat samllCircleViewRadius = MAX((cornerRadius - distance * 0.1) * 1.5, 0);
        self.samllCircleView.bounds = CGRectMake(0, 0, samllCircleViewRadius, samllCircleViewRadius);
        self.samllCircleView.layer.cornerRadius = samllCircleViewRadius * 0.5;
        if (distance > 0) {
            self.shapeLayer.path = [self shapeLayerPath].CGPath;
        }
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [_shapeLayer removeFromSuperlayer];
        _shapeLayer = nil;
        if (distance > self.maxDistance) {
            [self.samllCircleView removeFromSuperview];
            self.samllCircleView = nil;
            [UIView animateWithDuration:0.5 animations:^{
                self.alpha = 0;
            } completion:^(BOOL finished) {
                self.destroyRedDotBlock();
                [self removeFromSuperview];
            }];
        } else {
            //弹簧动画
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                self.center = self.samllCircleView.center;
            } completion:^(BOOL finished) {
                self.samllCircleView.hidden = NO;
            }];
        }
    }
    
}

/**
 求两个圆心间的距离
 */
- (CGFloat)centerDistanceWithPointA:(CGPoint)pointA potintB:(CGPoint)pointB {
    CGFloat offestX = pointA.x - pointB.x;
    CGFloat offestY = pointA.y - pointB.y;
    CGFloat distance = sqrtf(offestX * offestX + offestY * offestY);
    return distance;
}

/**
 不规则图形路径
 */
- (UIBezierPath *)shapeLayerPath {
    CGPoint bigCenter = self.center;
    CGFloat x2 = bigCenter.x;
    CGFloat y2 = bigCenter.y;
    CGFloat r2 = self.bounds.size.width / 2;
    
    CGPoint smallCenter = self.samllCircleView.center;
    CGFloat x1 = smallCenter.x;
    CGFloat y1 = smallCenter.y;
    CGFloat r1 = self.samllCircleView.bounds.size.width / 2;
    
    // 获取圆心距离
    CGFloat d = [self centerDistanceWithPointA:self.samllCircleView.center potintB:self.center];
    CGFloat sinθ = (x2 - x1) / d;
    CGFloat cosθ = (y2 - y1) / d;
    
    // 坐标系基于父控件
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ , y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ , y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ , y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ , y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d / 2 * sinθ , pointA.y + d / 2 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d / 2 * sinθ , pointB.y + d / 2 * cosθ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // A
    [path moveToPoint:pointA];
    // AB
    [path addLineToPoint:pointB];
    // 绘制BC曲线
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    // CD
    [path addLineToPoint:pointD];
    // 绘制DA曲线
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

- (UIView *)samllCircleView {
    if (!_samllCircleView) {
        UIView *samllCircleView = [[UIView alloc] init];
        samllCircleView.center = self.center;
        samllCircleView.backgroundColor = self.backgroundColor;
        [self.superview insertSubview:samllCircleView belowSubview:self];
        _samllCircleView = samllCircleView;
    }
    return _samllCircleView;
}

- (CAShapeLayer *)shapeLayer {
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.fillColor = self.backgroundColor.CGColor;
        [self.superview.layer insertSublayer:_shapeLayer below:self.layer];
    }
    return _shapeLayer;
}

@end

