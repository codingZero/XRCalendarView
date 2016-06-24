//
//  DateTool.m
//  日程模块
//
//  Created by 肖睿 on 16/6/22.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "DateTool.h"

static NSArray *weekDays;
static NSCalendar *calendar;

@implementation DateTool


+ (void)initialize {
    calendar = [NSCalendar currentCalendar];
    weekDays = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
}

+ (CompareResult)compareDate:(NSDate *)date1 withDate:(NSDate *)date2 {
    NSTimeInterval startInterval = [date1 timeIntervalSince1970];
    NSTimeInterval endInterval = [date2 timeIntervalSince1970];
    if (endInterval < startInterval) return CompareResultDesc;
    else if (endInterval > startInterval) return CompareResultAsc;
    else return CompareResultEqual;
}

+ (BOOL)components:(NSCalendarUnit)unit date:(NSDate *)date1 isEqualToDate:(NSDate *)date2 {
    NSDateComponents *comp1 = [calendar components:unit fromDate:date1];
    NSDateComponents *comp2 = [calendar components:unit fromDate:date2];
    return (comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day) && (comp1.hour == comp2.hour) && (comp1.minute == comp2.minute);
}


+ (NSDate *)date:(NSDate *)date addTimeInterval:(long long)timeInterval {
     NSTimeInterval interval = [date timeIntervalSince1970];
    interval += timeInterval;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}


+ (NSDate *)date:(NSDate *)date addDays:(NSInteger)days {
    return [self date:date addTimeInterval:days * 24 * 3600];
}

+ (NSDate *)date:(NSDate *)date addMonths:(NSInteger)months {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:months];
    return [calendar dateByAddingComponents:comps toDate:date options:0];
}

+ (NSInteger)getWeekdayFromDate:(NSDate *)date {
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
    return components.weekday;
}

+ (NSInteger)getMonthFromDate:(NSDate *)date {
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDate:date];
    return components.month;
}

+ (NSInteger)getDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:kNilOptions];
    return components.day;
}


+ (NSInteger)getMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateComponents *fromComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:fromDate];
    NSDateComponents *toComp = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:toDate];
    NSDateComponents *components = [calendar components:NSCalendarUnitMonth fromDateComponents:fromComp toDateComponents:toComp options:kNilOptions];
    return components.month;
}

+ (NSArray *)convertDateToStrArray:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    NSString *dateString = [formatter stringFromDate:date];
    NSString *timeStr = [dateString substringFromIndex:dateString.length - 5];
    NSString *dateStr;
    if ([calendar isDateInToday:date]) {
        dateStr = [NSString stringWithFormat:@"今天 %@", [dateString substringWithRange:NSMakeRange(5, 6)]];
    } else if ([calendar isDate:date equalToDate:[NSDate date] toUnitGranularity:NSCalendarUnitYear]) {
        NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:date];
        dateStr = [NSString stringWithFormat:@"%@ 星期%@", [dateString substringWithRange:NSMakeRange(5, 6)], weekDays[components.weekday - 1]];
    } else {
        dateStr = [dateString substringToIndex:11];
    }
    return @[dateStr, timeStr];
}

+ (NSDate *)convertDate:(NSDate *)date toDateWithHour:(NSString *)hour minute:(NSString *)minute {
    if ([minute hasPrefix:@":"]) minute = [minute substringFromIndex:1];
    minute = [NSString stringWithFormat:@"%02d", minute.intValue];
    NSString *time = [hour stringByReplacingCharactersInRange:NSMakeRange(3, 2) withString:minute];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [formatter stringFromDate:date];
    dateString = [dateString stringByAppendingFormat:@" %@", time];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:dateString];
}

+ (NSDate *)getLastDateInMonthWithDate:(NSDate *)date {
    NSInteger days = [self numberOfDaysInDate:date];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
    components.day = days;
    return [calendar dateFromComponents:components];
}

+ (NSInteger)numberOfDaysInDate:(NSDate *)date {
    NSRange days = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return days.length;
}

@end
