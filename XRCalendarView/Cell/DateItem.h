//
//  DateItem.h
//  日程模块
//
//  Created by 肖睿 on 16/6/22.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DateItem : UICollectionViewCell

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, assign) BOOL isSelect;
@end
