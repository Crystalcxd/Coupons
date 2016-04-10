//
//  WMUserDefault.h
//  WeMedia
//
//  Created by Kyle on 14-3-26.
//  Copyright (c) 2014年 Tap Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define kRefreshTimeInterval 60*60 //a hour
#define kLastCartoonSaveTime @"cartoon.savetime"
#define kCartoonListData @"cartoon.list"

#define kLastCouponsSaveTime @"coupons.savetime_%@"
#define kCouponsListData @"coupons.list_%@"

@interface WMUserDefault : NSObject

+(NSInteger)intValueForKey:(NSString *)key;
+(long)longValueForKey:(NSString *)key;
+(void)setIntValue:(NSInteger)value forKey:(NSString *)key;

+(CGFloat)floatValueForKey:(NSString *)key;
+(void)setFloatVaule:(CGFloat)value forKey:(NSString *)key;

+(BOOL)BoolValueForKey:(NSString *)key;
+(void)setBoolVaule:(BOOL)value forKey:(NSString *)key;

+(id)objectValueForKey:(NSString *)key;
+(void)setObjectValue:(id)value forKey:(NSString *)key;

+(void)setArray:(NSArray *)array forKey:(NSString *)key;
+ (NSArray *)arrayForKey:(NSString *)key;

@end
