//
//  DailyCartoon.m
//  Coupons
//
//  Created by Michael on 16/3/13.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "DailyCartoon.h"

@implementation DailyCartoon

- (void)dealloc
{
    //    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.dayNumber forKey:@"dayNumber"];
    [aCoder encodeObject:self.imageUrlDic forKey:@"imageUrlArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.dayNumber = [aDecoder decodeObjectForKey:@"dayNumber"];
        self.imageUrlDic = [aDecoder decodeObjectForKey:@"imageUrlArray"];
    }
    
    return self;
}

@end
