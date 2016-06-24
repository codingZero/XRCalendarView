//
//  DateItem.m
//  日程模块
//
//  Created by 肖睿 on 16/6/22.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "DateItem.h"
#import "DateTool.h"

@interface DateItem()

@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (nonatomic, strong) NSArray *months;
@end

@implementation DateItem


- (NSArray *)months {
    if (!_months) {
        _months = @[@"一月", @"二月", @"三月", @"四月", @"五月", @"六月", @"七月", @"八月", @"九月", @"十月", @"十一月", @"十二月"];
    }
    return _months;
}

- (void)setDate:(NSDate *)date {
    _date = date;
    if (!date) {
        _monthLabel.text = @"";
        _dayLabel.text = @"";
        return;
    }
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    if (components.day == 1 || [[NSCalendar currentCalendar] isDateInToday:date]) {
        _monthLabel.text = [NSString stringWithFormat:@"%@", self.months[components.month - 1]];
    } else {
        _monthLabel.text = @"";
    }
    
    _dayLabel.text = [NSString stringWithFormat:@"%ld", components.day];
}


- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    UIColor *blue = [UIColor colorWithRed:0.251 green:0.694 blue:1.000 alpha:1.000];
    UIColor *white = [UIColor whiteColor];
    UIColor *gray = [UIColor colorWithWhite:0.941 alpha:1.000];
    UIColor *black = [UIColor colorWithRed:0.220 green:0.235 blue:0.255 alpha:1.000];
    if (isSelect) {
        self.backgroundColor = blue;
        _monthLabel.textColor = white;
        _dayLabel.textColor = white;
    } else {
        if (_date && [[NSCalendar currentCalendar] isDateInToday:_date]) {
            _monthLabel.textColor = blue;
            _dayLabel.textColor = blue;
        } else {
            _monthLabel.textColor = black;
            _dayLabel.textColor = black;
        }
        if (_date && [DateTool getMonthFromDate:_date] % 2 == 0) {
            self.backgroundColor = gray;
        } else {
             self.backgroundColor = white;
        }
    }
}

@end
