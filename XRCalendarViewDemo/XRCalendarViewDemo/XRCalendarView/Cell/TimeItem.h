//
//  TimeItem.h
//  日程模块
//
//  Created by 肖睿 on 16/6/21.
//  Copyright © 2016年 肖睿. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimeItem : UICollectionViewCell

@property (nonatomic, strong) NSString *hour;
@property (nonatomic, assign) BOOL isSelect;
@end
