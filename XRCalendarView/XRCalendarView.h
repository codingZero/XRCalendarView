//
//  CalendarView.h
//  日程模块
//
//  Created by 肖睿 on 16/6/21.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XRCalendarView;

@protocol CalendarViewDelegate <NSObject>
/**
 *  选中日期时间后的回调
 *
 *  @param calendarView 日历控件
 *  @param date         选中的日期
 */
- (void)calendarView:(XRCalendarView *)calendarView didSelectDate:(NSDate *)date;

@end

@interface XRCalendarView : UIView

/**
 *  默认选中的日期
 */
@property (nonatomic, strong) NSDate *date;


/**
 *  日历的开始日期，默认为1970-01-01
 */
@property (nonatomic, strong) NSDate *startDate;


/**
 *  日历的结束日期，默认为当前日期加上10年
 */
@property (nonatomic, strong) NSDate *endDate;


/**
 *  代理，用来返回选中的日期
 */
@property (nonatomic, weak) id<CalendarViewDelegate> delegate;

/**
 *  滚动到指定的日期，默认为选中的日期
 */
- (void)scrollToDate:(NSDate *)date;

/**
 *  创建方法，默认高度为284
 *
 */
+ (instancetype)calendarView;
@end
