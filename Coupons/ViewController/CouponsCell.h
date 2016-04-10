//
//  CouponsCell.h
//  Coupons
//
//  Created by Michael on 15/6/5.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Coupons.h"

#import <AVOSCloud/AVOSCloud.h>

@protocol CouponsCellDelegate;

@interface CouponsCell : UITableViewCell

@property (nonatomic , assign) NSInteger index;
@property (nonatomic , assign) id<CouponsCellDelegate>delegate;

-(void)configCellWith:(Coupons *)coupons;

@end

@protocol CouponsCellDelegate <NSObject>
@optional

- (void)shareWith:(UIImage *)image;
- (void)showBigImageWith:(UIImage *)image;

@end
