//
//  GLCalendarMonthCoverView.m
//  GLPeriodCalendar
//
//  Created by ltebean on 15-4-17.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "MonthCoverView.h"
#import "DateTool.h"
#import "MonthTableViewCell.h"
@interface MonthCoverView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSDate *firstDate;
@property (nonatomic, strong) NSDate *lastDate;
@property (nonatomic, assign) CGFloat itemHeight;
@property (nonatomic, assign) NSInteger firstWeekday;
@property (nonatomic, assign) NSInteger numberOfRows;
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSNumber *> *cellHeightDic;
@end

static NSString *ID = @"monthCell";

@implementation MonthCoverView

- (NSMutableDictionary *)cellHeightDic {
    if (!_cellHeightDic) {
        _cellHeightDic = [NSMutableDictionary dictionary];
    }
    return _cellHeightDic;
}


- (void)awakeFromNib {
    self.dataSource = self;
    self.delegate = self;
    self.tableFooterView = [UIView new];
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self registerClass:[MonthTableViewCell class] forCellReuseIdentifier:ID];
}

- (void)updateWithFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate itemHeight:(CGFloat)itemHeight {
    _firstDate = firstDate;
    _lastDate = lastDate;
    _itemHeight = itemHeight;
    _firstWeekday = [DateTool getWeekdayFromDate:firstDate];
    _numberOfRows = [DateTool getMonthsFromDate:_firstDate toDate:_lastDate] + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MonthTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc] init];
    monthFormatter.dateFormat = @"YYYY\nMMM";
    NSDate *date = [DateTool date:_firstDate addMonths:indexPath.row];
    NSString *labelText = [monthFormatter stringFromDate:date];
    if ([DateTool components:NSCalendarUnitYear date:[NSDate date] isEqualToDate:date])
        labelText = [labelText substringFromIndex:5];
    cell.monthLabel.text = labelText;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *key = [NSString stringWithFormat:@"%ld", indexPath.row];
    if (self.cellHeightDic[key]) return self.cellHeightDic[key].floatValue;
    NSInteger rows = [self getRowsWithIndexPathRow:indexPath.row];
    if (indexPath.row == 0) {
        [self.cellHeightDic setObject:@(rows * _itemHeight) forKey:key];
    } else {
        NSInteger lastRows = [self getRowsWithIndexPathRow:indexPath.row - 1];
        [self.cellHeightDic setObject:@((rows - lastRows) * _itemHeight) forKey:key];
    }
    return self.cellHeightDic[key].floatValue;
}

- (NSInteger)getRowsWithIndexPathRow:(NSInteger)row {
    NSInteger days = 0;
    if (row != _numberOfRows - 1) {
        NSDate *date = [DateTool date:_firstDate addMonths:row];
        NSDate *lastDate = [DateTool getLastDateInMonthWithDate:date];
        days = [DateTool getDaysFromDate:_firstDate toDate:lastDate];
    } else {
        days = [DateTool getDaysFromDate:_firstDate toDate:_lastDate];
    }
    
    return (days + _firstWeekday + 6) / 7;
}


@end
