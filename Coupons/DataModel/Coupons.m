//
//  Coupons.m
//  Coupons
//
//  Created by Michael on 15/8/7.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "Coupons.h"

#import "Utility.h"

@implementation Coupons

- (void)dealloc
{
//    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.price forKey:@"price"];
    [aCoder encodeObject:self.date forKey:@"date"];
    [aCoder encodeObject:self.imgUrl forKey:@"imgUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.price = [aDecoder decodeObjectForKey:@"price"];
        self.date = [aDecoder decodeObjectForKey:@"date"];
        self.imgUrl = [aDecoder decodeObjectForKey:@"imgUrl"];
    }
    
    return self;
}

+ (Coupons *)parseObject:(AVObject *)object
{
    if ([Utility isInValid:object]) {
        return nil;
    }
    
    AVFile *file = [object objectForKey:@"image"];

    Coupons *coupons = [[Coupons alloc] init];
    
    coupons.content = object[@"content"];
    coupons.price = object[@"price"];
    coupons.date = object[@"date"];
    
    coupons.imgUrl = file.url;
    
    return coupons;
}

@end
