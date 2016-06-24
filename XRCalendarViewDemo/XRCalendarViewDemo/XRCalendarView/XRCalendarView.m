//
//  CalendarView.m
//  日程模块
//
//  Created by 肖睿 on 16/6/21.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "XRCalendarView.h"
#import "TimeItem.h"
#import "DateItem.h"
#import "DateTool.h"
#import "MonthCoverView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width

@interface CalendarBtn: UIButton
@end

@implementation CalendarBtn
- (void)setHighlighted:(BOOL)highlighted {}
@end



@interface XRCalendarView()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *dateBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIView *timeView;

@property (weak, nonatomic) IBOutlet UIView *minuteView;
@property (weak, nonatomic) IBOutlet UICollectionView *hourCollectionView;
@property (weak, nonatomic) IBOutlet UIView *dateView;

@property (weak, nonatomic) IBOutlet UICollectionView *dateCollectionView;
@property (weak, nonatomic) IBOutlet MonthCoverView *monthCoverView;
@property (nonatomic, strong) NSArray *hours;

@property (nonatomic, weak) UIButton *selectMinute;
@property (nonatomic, assign) NSInteger selectHour;
@property (nonatomic, assign) NSInteger selectDate;

@property (nonatomic, assign) NSInteger firstWeekday;
@end

static NSString *timeCell = @"timeItem";
static NSString *dateCell = @"dateCell";

@implementation XRCalendarView

- (NSDate *)startDate {
    if (!_startDate) {
        _startDate = [NSDate dateWithTimeIntervalSince1970:0];
    }
    return _startDate;
}


- (NSDate *)endDate {
    if (!_endDate) {
        _endDate = [NSDate dateWithTimeIntervalSinceNow:86400*365*10];
    }
    return _endDate;
}



- (NSArray *)hours {
    if (!_hours) {
        _hours = @[@"08:00", @"09:00", @"10:00", @"11:00", @"12:00", @"13:00",
                   @"14:00", @"15:00", @"16:00", @"17:00", @"18:00", @"19:00",
                   @"20:00", @"21:00", @"22:00", @"23:00", @"00:00", @"01:00",
                   @"02:00", @"03:00", @"04:00", @"05:00", @"06:00", @"07:00"];
    }
    return _hours;
}


+ (instancetype)calendarView {
    return [[NSBundle mainBundle] loadNibNamed:@"XRCalendarView" owner:nil options:nil].firstObject;
}


- (void)awakeFromNib {
    self.autoresizingMask = UIViewAutoresizingNone;
    CGRect frame = self.frame;
    frame.size.width = ScreenWidth;
    self.frame = frame;

    _selectDate = -1;
    _firstWeekday = [DateTool getWeekdayFromDate:self.startDate] - 1;
    [self setUpHourCollectionView];
    [self setUpminuteView];
    [self setUpDateCollectionView];
    
    self.date = [NSDate date];
}


- (void)layoutSubviews {
     [self.monthCoverView updateWithFirstDate:self.startDate lastDate:self.endDate itemHeight:45.5];
}


- (void)setUpHourCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (ScreenWidth - 47.5) / 6;
    CGFloat itemH = (_hourCollectionView.frame.size.height - 1.5) / 4;
    flowLayout.itemSize = CGSizeMake(itemW, itemH);
    flowLayout.minimumInteritemSpacing = 0.5;
    flowLayout.minimumLineSpacing = 0.5;
    _hourCollectionView.collectionViewLayout = flowLayout;
    [_hourCollectionView registerClass:[TimeItem class] forCellWithReuseIdentifier:timeCell];
}

- (void)setUpDateCollectionView {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (ScreenWidth - 3) / 7;
    flowLayout.itemSize = CGSizeMake(itemW, 45);
    flowLayout.minimumInteritemSpacing = 0.5;
    flowLayout.minimumLineSpacing = 0.5;
    _dateCollectionView.collectionViewLayout = flowLayout;
    _dateCollectionView.bounces = NO;
    _dateCollectionView.showsVerticalScrollIndicator = NO;
    [_dateCollectionView registerNib:[UINib nibWithNibName:@"DateItem" bundle:nil] forCellWithReuseIdentifier:dateCell];
}

- (void)setUpminuteView {
    CGFloat btnMargin = 2;
    CGFloat btnW = (ScreenWidth - btnMargin * 13) / 12;
    CGFloat btnH = 48;
    CGFloat btnY = (_minuteView.frame.size.height - btnH) * 0.5;
    for (int i = 0; i < 12; i++) {
        CalendarBtn *btn = [[CalendarBtn alloc] initWithFrame:CGRectMake(btnMargin + i * (btnW + btnMargin), btnY, btnW, btnH)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectMinute:) forControlEvents:UIControlEventTouchUpInside];
        [btn setBackgroundImage:[UIImage imageNamed:@"timecolor_blue"] forState:UIControlStateSelected];
        if (i % 3 == 0) {
            [btn setTitle:[NSString stringWithFormat:@":%d", i * 5] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:15];
            [btn setTitleColor:[UIColor colorWithRed:0.220 green:0.235 blue:0.255 alpha:1.000] forState:UIControlStateNormal];
        } else {
            [btn setTitle:[NSString stringWithFormat:@"%d", i * 5] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn setTitleColor:[UIColor colorWithRed:0.510 green:0.576 blue:0.620 alpha:1.000] forState:UIControlStateNormal];
        }
        [_minuteView addSubview:btn];
        
    }
}

- (void)selectMinute:(UIButton *)btn {
    if (_selectMinute == btn) return;
    btn.selected = YES;
    _selectMinute.selected = NO;
    _selectMinute = btn;
    [self selectedDate];
}

- (IBAction)btnClick:(UIButton *)sender {
    _dateBtn.selected = sender == _dateBtn;
    _timeBtn.selected = !_dateBtn.selected;
    _dateView.hidden = !_dateBtn.selected;
    _timeView.hidden = !_timeBtn.selected;
    if (_dateBtn.selected) {
        [self scrollToDate:_date];
    }
}


- (void)setDate:(NSDate *)date {
    _date = date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSString *timeStr = [formatter stringFromDate:date];
    NSString *minute = [timeStr substringFromIndex:timeStr.length - 2];
    int index = minute.intValue / 5;
    
    CalendarBtn *btn = _minuteView.subviews[index];
    _selectMinute.selected = NO;
    btn.selected = YES;
    _selectMinute = btn;
    
    NSString *hour = [timeStr substringToIndex:timeStr.length - 2];
    for (int i = 0; i < self.hours.count; i++) {
        NSString *h = self.hours[i];
        if ([h hasPrefix:hour]) {
            _selectHour = i;
            [_hourCollectionView reloadData];
        }
    }
    
    NSInteger days = [DateTool getDaysFromDate:self.startDate toDate:date];
    _selectDate = days + _firstWeekday;
    [_dateCollectionView reloadData];

}

- (void)selectedDate {
    if ([_delegate respondsToSelector:@selector(calendarView:didSelectDate:)]) {
        NSDate *date = [DateTool date:self.startDate addDays:_selectDate - _firstWeekday];
        NSString *hour = self.hours[_selectHour];
        NSString *minute = [_selectMinute titleForState:UIControlStateNormal];
        date = [DateTool convertDate:date toDateWithHour:hour minute:minute];
        _date = date;
        [_delegate calendarView:self didSelectDate:date];
    }
}

- (void)scrollToDate:(NSDate *)date {
    if (!date) return;
    NSInteger days = [DateTool getDaysFromDate:self.startDate toDate:date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_firstWeekday + days inSection:0];
    [_dateCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}


#pragma mark- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger days = [DateTool getDaysFromDate:self.startDate toDate:self.endDate];
    return collectionView == _hourCollectionView?self.hours.count: days + _firstWeekday;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _hourCollectionView) {
        TimeItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:timeCell forIndexPath:indexPath];
        item.hour = self.hours[indexPath.item];
        item.isSelect = _selectHour == indexPath.item;
        return item;
    } else {
        DateItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:dateCell forIndexPath:indexPath];
        if (indexPath.item >= _firstWeekday) {
            item.date = [DateTool date:self.startDate addDays:indexPath.item - _firstWeekday];
        } else item.date = nil;
        item.isSelect = _selectDate == indexPath.item;
        
        return item;
    }
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _hourCollectionView) _selectHour = indexPath.item;
    else _selectDate = indexPath.item;
    [collectionView reloadData];
    [self selectedDate];
}


# pragma mark - UIScrollView delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _monthCoverView.hidden = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    _monthCoverView.contentOffset = _dateCollectionView.contentOffset;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) _monthCoverView.hidden = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _monthCoverView.hidden = YES;
}

@end
