//
//  TimeItem.m
//  日程模块
//
//  Created by 肖睿 on 16/6/21.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "TimeItem.h"



@implementation TimeItem {
    UILabel *_timeLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textAlignment = NSTextAlignmentCenter;
        timeLabel.font = [UIFont systemFontOfSize:15];
        timeLabel.textColor = [UIColor colorWithRed:0.220 green:0.235 blue:0.255 alpha:1.000];
        [self.contentView addSubview:timeLabel];
        _timeLabel = timeLabel;
    }
    return self;
}

- (void)layoutSubviews {
    _timeLabel.frame = self.bounds;
}

- (void)setHour:(NSString *)hour {
    _hour = hour;
    NSMutableAttributedString *attHour = [[NSMutableAttributedString alloc] initWithString:hour];
    NSRange range = [hour rangeOfString:@":00"];
    [attHour addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    _timeLabel.attributedText = attHour;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    if (isSelect) {
        _timeLabel.backgroundColor = [UIColor colorWithRed:0.251 green:0.694 blue:1.000 alpha:1.000];
        _timeLabel.textColor = [UIColor whiteColor];
    } else {
        _timeLabel.backgroundColor = [UIColor whiteColor];
        _timeLabel.textColor = [UIColor colorWithRed:0.220 green:0.235 blue:0.255 alpha:1.000];
    }
}

@end
