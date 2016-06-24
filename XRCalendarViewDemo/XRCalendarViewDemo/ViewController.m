//
//  ViewController.m
//  XRCalendar
//
//  Created by 肖睿 on 16/6/23.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "ViewController.h"
#import "XRCalendarView.h"
@interface ViewController ()<CalendarViewDelegate>
@property (nonatomic, strong) XRCalendarView *calendar;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    XRCalendarView *calendar = [XRCalendarView calendarView];
    calendar.frame = CGRectMake(0, 50, 375, self.view.frame.size.height - 100);
    //设置开始日期
    calendar.startDate = [NSDate dateWithTimeIntervalSinceNow:-86400*365*5];
    //设置结束日期
    calendar.endDate = [NSDate dateWithTimeIntervalSinceNow:86400*365*5];
    //设置默认的选中时间，不设置则为当前时间
    calendar.date = [NSDate dateWithTimeIntervalSinceNow:86400*2];
    
    calendar.delegate = self;
    
    [self.view addSubview:calendar];
    _calendar = calendar;

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_calendar scrollToDate:[NSDate date]];
}

- (void)calendarView:(XRCalendarView *)calendarView didSelectDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSLog(@"%@", [formatter stringFromDate:date]);
}

@end
