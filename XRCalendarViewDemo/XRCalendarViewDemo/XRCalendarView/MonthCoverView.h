//
//  GLCalendarMonthCoverView.h
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-17.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthCoverView : UITableView
@property (nonatomic, strong) NSDictionary *textAttributes;
- (void)updateWithFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate  itemHeight:(CGFloat)itemHeight;
@end
