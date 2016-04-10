//
//  Coupons.h
//  Coupons
//
//  Created by Michael on 15/8/7.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVOSCloud/AVOSCloud.h>

@interface Coupons : NSObject

@property (nonatomic , strong) NSString *content;
@property (nonatomic , strong) NSString *price;
@property (nonatomic , strong) NSString *date;
@property (nonatomic , strong) NSString *imgUrl;

+(Coupons *)parseObject:(AVObject *)object;

@end
