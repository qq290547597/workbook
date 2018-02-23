//
//  LockView.m
//  m4399_GameVideo
//
//  Created by lixinjie on 2018/1/3.
//  Copyright © 2018年 4399 Network Co., Ltd. All rights reserved.
//  手势解锁

#import "LockView.h"

@interface LockView ()

@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, strong) NSMutableArray *selectedButton;
@property (nonatomic, strong) NSMutableArray *buttonArr;
@property (nonatomic, assign) CGPoint currentPoint;

@end

@implementation LockView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addButton];
        [self addLabel];
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:pan];
    }
    return self;
}

- (void)addLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.bounds.size.width, 30)];
    label.textColor = [UIColor blackColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    [self addSubview:label];
    self.toastLabel = label;
}

- (void)addButton {
    self.buttonArr = [NSMutableArray array];
    //添加九宫格按钮
    NSInteger row = 3;
    NSInteger column = 3;
    CGFloat w = 70;
    CGFloat h = w;
    CGFloat margin = (self.bounds.size.width - row * w) / (row + 1);
    CGFloat marginY = self.center.y - row * 0.5 * h - (row - 1) * 0.5 * margin;
    NSInteger tag = 1;
    for (NSInteger i = 0; i < column; i++) {
        for (NSInteger j = 0; j < row; j++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button setFrame:CGRectMake(margin + j * (w + margin), marginY + i * (h + margin), w, h)];
            button.userInteractionEnabled = NO;
            [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]] forState:UIControlStateNormal];
            [button setBackgroundImage:[self createImageWithColor:[UIColor colorWithRed:0 green:1 blue:1 alpha:0.5]] forState:UIControlStateSelected];
            [button setTitle:[NSString stringWithFormat:@"%zd", tag] forState:UIControlStateNormal];
            [self addSubview:button];
            [self.buttonArr addObject:button];
            tag ++;
        }
    }
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    //获取当前触摸点
    CGPoint currentPoint = [pan locationInView:self];
    self.currentPoint = currentPoint;
    for (UIButton *btn in self.buttonArr) {
        if (CGRectContainsPoint(btn.frame, currentPoint) && btn.selected == NO) {
            [btn setSelected:YES];
            [self.selectedButton addObject:btn];
            self.toastLabel.text = [NSString stringWithFormat:@"%@%@", self.toastLabel.text, btn.titleLabel.text];
        }
    }
    //重绘
    [self setNeedsDisplay];
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        //取消所有按钮的全中状态
        for (UIButton *btn in self.selectedButton) {
            [btn setSelected:NO];
        }
        [self.selectedButton removeAllObjects];
        self.toastLabel.text = @"";
    }
}

- (void)drawRect:(CGRect)rect {
    NSUInteger count = self.selectedButton.count;
    if (count == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < count; i++) {
        UIButton *btn = self.selectedButton[i];
        if (i == 0) {
            //设置起点
            [path moveToPoint:btn.center];
        } else {
            [path addLineToPoint:btn.center];
        }
    }
    
    [path addLineToPoint:self.currentPoint];
    
    [[UIColor greenColor] set];
    path.lineWidth = 5;
    path.lineJoinStyle = kCGLineJoinRound;
    [path stroke];
}

- (NSMutableArray *)selectedButton {
    if (!_selectedButton) {
        _selectedButton = [NSMutableArray array];
    }
    return _selectedButton;
}

/**
 颜色转图片
 */
- (UIImage *)createImageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
