//
//  CityCell.h
//  Coupons
//
//  Created by Michael on 15/7/9.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVOSCloud/AVOSCloud.h>

@interface CityCell : UITableViewCell

-(void)configCellWith:(AVObject *)object;
-(void)updateSelectState:(BOOL)selected;

@end
