//
//  CartoonCell.h
//  Coupons
//
//  Created by Michael on 16/3/13.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartoonCell : UITableViewCell

-(void)configCellWith:(NSString *)imgUrl;

+ (CGFloat)calculateCellHeightWith:(NSString *)imgUrl;

@end
