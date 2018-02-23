//
//  ClockView.m
//  练习册
//
//  Created by lixinjie on 2018/2/6.
//  Copyright © 2018年 lixinjie. All rights reserved.
//  时钟

#import "ClockView.h"

@implementation ClockView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView {
    UIView *clockView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    clockView.center = self.center;
    clockView.backgroundColor = [UIColor lightGrayColor];
    clockView.layer.cornerRadius = 100;
    [self addSubview:clockView];
    
    CGFloat r = clockView.bounds.size.width / 2 - 10;
    for (NSInteger i = 0; i < 12; i++) {
        CATextLayer *text = [CATextLayer layer];
        text.string = (id)[NSString stringWithFormat:@"%zd", i + 1];
        text.fontSize = 14;
        text.contentsScale = 2;
        text.font = (__bridge CFTypeRef)(@"HiraKakuProN-W3");
        text.alignmentMode = @"center";
        text.foregroundColor = [UIColor blackColor].CGColor;
        text.position = CGPointMake(clockView.bounds.size.width / 2 + r * cos((i - 2) * 360 / 12 * M_PI / 180.0), clockView.bounds.size.height / 2 + r * sin((i - 2) * 360 / 12 * M_PI / 180.0));
        text.bounds = CGRectMake(0, 0, 20, 20);
        [clockView.layer addSublayer:text];
    }
    
    
    //秒针
    CALayer *second = [CALayer layer];
    second.backgroundColor = [UIColor redColor].CGColor;
    second.anchorPoint = CGPointMake(0.5, 0.95);
    second.position = CGPointMake(clockView.bounds.size.width / 2, clockView.bounds.size.height / 2);
    second.bounds = CGRectMake(0, 0, 2, clockView.bounds.size.height / 2);
    second.cornerRadius = second.bounds.size.width / 2;
    
    //分针
    CALayer *minute = [CALayer layer];
    minute.backgroundColor = [UIColor blackColor].CGColor;
    minute.anchorPoint = CGPointMake(0.5, 1);
    minute.position = second.position;
    minute.bounds = CGRectMake(0, 0, second.bounds.size.width + 2, second.bounds.size.height * second.anchorPoint.y);
    minute.cornerRadius = minute.bounds.size.width / 2;
    
    //时针
    CALayer *hour = [CALayer layer];
    hour.backgroundColor = [UIColor blackColor].CGColor;
    hour.anchorPoint = minute.anchorPoint;
    hour.position = second.position;
    hour.bounds = CGRectMake(0, 0, minute.bounds.size.width, second.bounds.size.height * 2 / 3);
    hour.cornerRadius = hour.bounds.size.width / 2;
    
    [clockView.layer addSublayer:hour];
    [clockView.layer addSublayer:minute];
    [clockView.layer addSublayer:second];
    
    //获取当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new]];
    //弧度转角度公式：弧度 * 180 / π
    second.transform = CATransform3DMakeRotation(dateComponents.second * 360 / 60 / 180.0 * M_PI, 0, 0, 1);
    minute.transform = CATransform3DMakeRotation(dateComponents.minute * 360 / 60 / 180.0 * M_PI, 0, 0, 1);
    hour.transform = CATransform3DMakeRotation((dateComponents.hour + dateComponents.minute / 60.0) * 360 / 12 / 180.0 * M_PI, 0, 0, 1);
    
    [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        NSDateComponents *dateComponents = [calendar components:NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate new]];
        second.transform = CATransform3DMakeRotation(dateComponents.second * 360 / 60 / 180.0 * M_PI, 0, 0, 1);
        minute.transform = CATransform3DMakeRotation(dateComponents.minute * 360 / 60 / 180.0 * M_PI, 0, 0, 1);
        hour.transform = CATransform3DMakeRotation((dateComponents.hour + dateComponents.minute / 60.0) * 360 / 12 / 180.0 * M_PI, 0, 0, 1);
    }];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
