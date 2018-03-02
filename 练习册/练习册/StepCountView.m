//
//  StepCountView.m
//  练习册
//
//  Created by lixinjie on 2018/2/28.
//  Copyright © 2018年 lixinjie. All rights reserved.
//

#import "StepCountView.h"
#import <HealthKit/HealthKit.h>

@interface StepCountView () <UITextFieldDelegate>

@property (nonatomic, strong) HKHealthStore *healthStore;
@property (nonatomic, strong) UILabel *readStepLabel;
@property (nonatomic, strong) UITextField *writeStepTextField;

@end

@implementation StepCountView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addView];
    }
    return self;
}

- (void)addView {
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width - 20, 30)];
    textLabel.center = self.center;
    textLabel.textColor = [UIColor blackColor];
    textLabel.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:textLabel];
    self.readStepLabel = textLabel;
    
    if ([HKHealthStore isHealthDataAvailable]) {
        self.healthStore = [[HKHealthStore alloc] init];
        NSSet *writeDataTypes = [self dataTypesToWrite];
        NSSet *readDataTypes = [self dataTypesToRead];
        [self.healthStore requestAuthorizationToShareTypes:writeDataTypes readTypes:readDataTypes completion:^(BOOL success, NSError *error) {
            if (!success) {
                textLabel.text = [NSString stringWithFormat:@"未授权读/写权限。error【%@】", error];
                return;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                // Update the user interface based on the current user's health information.
                [self stepCount];
                
                self.writeStepTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.readStepLabel.frame.origin.x, CGRectGetMaxY(self.readStepLabel.frame) + 10, 100, self.readStepLabel.frame.size.height)];
                self.writeStepTextField.backgroundColor = self.readStepLabel.backgroundColor;
                self.writeStepTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                self.writeStepTextField.placeholder = @"增加步数";
                self.writeStepTextField.returnKeyType = UIReturnKeySend;
                self.writeStepTextField.delegate = self;
                [self addSubview:self.writeStepTextField];
            });
        }];
    } else {
        textLabel.text = @"该设备无法获取数据！";
    }
    
}

// Returns the types of data that Fit wishes to write to HealthKit.
- (NSSet *)dataTypesToWrite {
//    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
//    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
//    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//
//    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType,stepType, nil];
    return [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil];
}

// Returns the types of data that Fit wishes to read from HealthKit.
- (NSSet *)dataTypesToRead {
//    HKQuantityType *dietaryCalorieEnergyType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryEnergyConsumed];
//    HKQuantityType *activeEnergyBurnType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierActiveEnergyBurned];
//    HKQuantityType *heightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierHeight];
//    HKQuantityType *weightType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
//    HKCharacteristicType *birthdayType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierDateOfBirth];
//    HKCharacteristicType *biologicalSexType = [HKObjectType characteristicTypeForIdentifier:HKCharacteristicTypeIdentifierBiologicalSex];
//    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
//
//    return [NSSet setWithObjects:dietaryCalorieEnergyType, activeEnergyBurnType, heightType, weightType, birthdayType, biologicalSexType,stepType, nil];
    return [NSSet setWithObjects:[HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount], nil];
}


- (void)stepCount {
    HKQuantityType *stepType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self fetchSumOfSamplesTodayForType:stepType unit:[HKUnit countUnit] completion:^(double healthStepCount, double otherStepCount, double sumStepCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            _readStepLabel.text = [NSString stringWithFormat:@"健康步数:%.f,其他步数:%.f,总步数:%.f", healthStepCount, otherStepCount, sumStepCount];
        });
    }];
}

- (void)fetchSumOfSamplesTodayForType:(HKQuantityType *)quantityType unit:(HKUnit *)unit completion:(void (^)(double healthStepCount, double otherStepCount, double sumStepCount, NSError *error))completionHandler {
    NSPredicate *predicate = [self predicateForSamplesToday];
    /*
    HKStatisticsQuery *query = [[HKStatisticsQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options:HKStatisticsOptionCumulativeSum completionHandler:^(HKStatisticsQuery *query, HKStatistics *result, NSError *error) {
        HKQuantity *sum = [result sumQuantity];
        if (completionHandler) {
            double value = [sum doubleValueForUnit:unit];
            completionHandler(value, error);
        }
    }];
    [self.healthStore executeQuery:query];
    */
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = 1;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *startDate = [calendar startOfDayForDate:now];
    
    HKStatisticsCollectionQuery *collectionQuery = [[HKStatisticsCollectionQuery alloc] initWithQuantityType:quantityType quantitySamplePredicate:predicate options: HKStatisticsOptionCumulativeSum | HKStatisticsOptionSeparateBySource anchorDate:startDate intervalComponents:dateComponents];
    collectionQuery.initialResultsHandler = ^(HKStatisticsCollectionQuery *query, HKStatisticsCollection * __nullable result, NSError * __nullable error) {
        double healthStepCount = 0, otherStepCount = 0, sumStepCount = 0;
        for (HKStatistics *statistic in result.statistics) {
            sumStepCount += [[statistic sumQuantity] doubleValueForUnit:unit];
            for (HKSource *source in statistic.sources) {
                //过滤掉其他软件的步数统计，微信支付宝也做了过滤
                if ([source.bundleIdentifier hasPrefix:@"com.apple.health"]) {
                    //健康中的步数
                    healthStepCount += [[statistic sumQuantityForSource:source] doubleValueForUnit:unit];
                } else {
                    //其他软件添加的步数
                    otherStepCount += [[statistic sumQuantityForSource:source] doubleValueForUnit:unit];
                }
            }
        }
        if (completionHandler) {
            completionHandler(healthStepCount, otherStepCount, sumStepCount, error);
        }
    };
    [self.healthStore executeQuery:collectionQuery];
}

- (NSPredicate *)predicateForSamplesToday {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDate *startDate = [calendar startOfDayForDate:now];
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    return [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionStrictStartDate];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.text.integerValue != 0) {
        [self addstepWithStepNum:textField.text.integerValue];
    }
    textField.text = nil;
    [textField resignFirstResponder];
    return YES;
}


/**
 增加步数（不一定会全部累加到健康步数中）
 */
- (void)addstepWithStepNum:(double)stepNum {
    // Create a new food correlation for the given food item.
    HKQuantitySample *stepCorrelationItem = [self stepCorrelationWithStepNum:stepNum];
    [self.healthStore saveObject:stepCorrelationItem withCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.readStepLabel.frame.origin.y - 45, self.bounds.size.width, 30)];
            textLabel.textColor = [UIColor redColor];
            textLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:textLabel];
            
            if (success) {
                textLabel.text = @"添加成功";
                [self stepCount];
            } else {
                textLabel.text = @"添加失败";
            }
            [UIView animateWithDuration:0 delay:2 options:UIViewAnimationOptionCurveLinear animations:^{
                textLabel.alpha = 0;
            } completion:^(BOOL finished) {
                [textLabel removeFromSuperview];
            }];
        });
    }];
}

- (HKQuantitySample *)stepCorrelationWithStepNum:(double)stepNum {
    //每秒2.5步
    NSDate *endDate = [NSDate date];
    NSDate *startDate = [NSDate dateWithTimeInterval:-labs((long)(stepNum / 2.5)) sinceDate:endDate];
    
    HKQuantity *stepQuantityConsumed = [HKQuantity quantityWithUnit:[HKUnit countUnit] doubleValue:stepNum];
    
    HKQuantityType *stepConsumedType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    HKQuantitySample *stepConsumedSample = [HKQuantitySample quantitySampleWithType:stepConsumedType quantity:stepQuantityConsumed startDate:startDate endDate:endDate device:[HKDevice localDevice] metadata:nil];
    return stepConsumedSample;
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
