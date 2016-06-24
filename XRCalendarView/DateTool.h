//
//  DateTool.h
//  日程模块
//
//  Created by 肖睿 on 16/6/22.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    CompareResultAsc,
    CompareResultDesc,
    CompareResultEqual
} CompareResult;



@interface DateTool : NSObject
+ (NSArray *)convertDateToStrArray:(NSDate *)date;
+ (CompareResult)compareDate:(NSDate *)date1 withDate:(NSDate *)date2;
+ (BOOL)components:(NSCalendarUnit)unit date:(NSDate *)date1 isEqualToDate:(NSDate *)date2;
+ (NSDate *)date:(NSDate *)date addTimeInterval:(long long)timeInterval;
+ (NSDate *)date:(NSDate *)date addDays:(NSInteger)days;
+ (NSDate *)date:(NSDate *)date addMonths:(NSInteger)months;
+ (NSDate *)getLastDateInMonthWithDate:(NSDate *)date;
+ (NSDate *)convertDate:(NSDate *)date toDateWithHour:(NSString *)hour minute:(NSString *)minute;
+ (NSInteger)getWeekdayFromDate:(NSDate *)date;
+ (NSInteger)getMonthFromDate:(NSDate *)date;
+ (NSInteger)getDaysFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)getMonthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;
+ (NSInteger)numberOfDaysInDate:(NSDate *)date;
@end
