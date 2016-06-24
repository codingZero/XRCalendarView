//
//  MonthTableViewCell.m
//  日程模块
//
//  Created by 肖睿 on 16/6/23.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import "MonthTableViewCell.h"

@implementation MonthTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:25];
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:label];
        _monthLabel = label;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.monthLabel.frame = self.contentView.bounds;
}

@end
