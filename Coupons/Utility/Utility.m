//
//  Utility.m
//  WeMedia
//
//  Created by Kyle on 14-4-1.
//  Copyright (c) 2014年 Tap Tech. All rights reserved.
//

#import "Utility.h"
@implementation Utility
NSUInteger DeviceSystemMajorVersion(){
    static NSUInteger _deviceSystemMajorVersion = -1;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _deviceSystemMajorVersion = [[[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."] objectAtIndex:0] intValue];
	});
    
	return _deviceSystemMajorVersion;
}

+(NSString *)convertToString:(NSTimeInterval)timeInterval formatter:(NSDateFormatter *)dateFormatter;
{
    NSDateFormatter *defaultMatter = nil;
    if (dateFormatter == nil) {
        defaultMatter = [[NSDateFormatter alloc] init];
        [defaultMatter setDateFormat:@"YYYY年MM月dd日"];
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSString *dateStrng = nil;
    if (dateFormatter != nil) {
        dateStrng= [dateFormatter stringFromDate:date];
    }else{
        dateStrng= [defaultMatter stringFromDate:date];

    }
    return dateStrng;
}

+(NSString *)dateStringWith:(NSInteger)time
{
    NSInteger length = 60*60*24*30*12;//一年
    
    NSString *dateString = nil;
    
    NSInteger currenttime = [[NSDate date] timeIntervalSince1970];
    NSInteger distance = currenttime - time;
    
    int num = 0;
    
    if (distance/(length) >= 1) {
        num = (int)(distance/length);
        dateString = [NSString stringWithFormat:@"%d年前",num];
        return dateString;
    }
    length = length/12;
    if (distance/(length) >= 1) {
        num = (int)(distance/length);
        dateString = [NSString stringWithFormat:@"%d个月前",num];
        return dateString;
    }
    length = length/30;
    if (distance/length >= 1) {
        if (distance/(length) == 1) {
            dateString = @"昨天";
            return dateString;
        }else{
            num = (int)(distance/length);
            dateString = [NSString stringWithFormat:@"%d天前",num];
            return dateString;
        }
    }
    length = length/24;
    if (distance/(length) >= 1) {
        num = (int)(distance/length);
        dateString = [NSString stringWithFormat:@"%d小时前",num];
        return dateString;
    }
    length = length/60;
    if (distance/(length) >= 1) {
        num = (int)(distance/length);
        dateString = [NSString stringWithFormat:@"%d分钟前",num];
        return dateString;
    }else
        return @"刚刚";
}

+ (NSString *)chatTimeStringWith:(NSInteger)time
{
    NSDateFormatter *defaultMatter = nil;
    
    defaultMatter = [[NSDateFormatter alloc] init];
    [defaultMatter setDateFormat:@"YYYY-MM-dd"];
    
    NSDate *timeDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDate *curDate = [NSDate date];
    
    NSString *timeString = [defaultMatter stringFromDate:timeDate];
    NSString *curString = [defaultMatter stringFromDate:curDate];
    if ([timeString isEqual:curString]) {
        [defaultMatter setDateFormat:@"HH:mm"];
        NSString *tempString = [defaultMatter stringFromDate:timeDate];
        return [NSString stringWithFormat:@"今天 %@",tempString];
    }
    
    [defaultMatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    NSString *tempString = [defaultMatter stringFromDate:timeDate];
    return tempString;
}

+(NSInteger)safeIntValueWith:(id)objc
{
    if ([objc isKindOfClass:[NSNull class]]&&objc == nil) {
        return 0;
    }
    if ([objc isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)objc;
        return str.integerValue;
    }
    if ([objc isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)objc;
        return number.integerValue;
    }
    return 0;
}

+(BOOL)safeBoolValueWith:(id)objc
{
    if ([objc isKindOfClass:[NSNull class]]&&objc == nil) {
        return NO;
    }
    if ([objc isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)objc;
        return str.boolValue;
    }
    if ([objc isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)objc;
        return number.boolValue;
    }
    return NO;
}

+(NSString *)safeStringWith:(id)objc
{
    if ([objc isKindOfClass:[NSNull class]]||objc == nil) {
        return @"";
    }else if ([objc isKindOfClass:[NSNumber class]]) {
        NSNumber *number = (NSNumber *)objc;
        return number.stringValue;
    }
        return objc;
}

+(NSString *)dateStringFrom:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSString *dateString = [df stringFromDate:date];
    
    return dateString;
}

+(BOOL)isInValid:(id)objc
{
    if (objc == nil||[objc isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

+(BOOL)emptyString:(NSString *)str
{
    NSInteger count = str.length;
    
    int emptyCount = 0;
    
    for (int i = 0; i < count; i++) {
        NSString *string = [str substringWithRange:NSMakeRange(i, 1)];
        if ([string isEqualToString:@" "]) {
            emptyCount++;
        }
    }
    
    if (emptyCount == count) {
        return YES;
    }
    
    return NO;
}

+ (NSString *)starDesWith:(NSString *)star
{
    NSInteger starPoint = star.integerValue;
    
    switch (starPoint) {
        case 1:
            return @"重踩";
            break;
        case 2:
            return @"轻踩";
            break;
        case 3:
            return @"已阅";
            break;
        case 4:
            return @"小推";
            break;
        case 5:
            return @"强推";
            break;
        default:
            return @"";
            break;
    }
}

+(UIColor *)colorWith:(NSString *)star
{
    NSInteger starPoint = star.integerValue;

    if (starPoint >= 4) {
        return kNavBGColor;
    }else{
        return [UIColor lightGrayColor];
    }
}

+(int)getRightIndex:(NSString*)resource forWidth:(float)width withFont:(UIFont*)font
{
    for(int i=1;i<resource.length;i++)
    {
        NSString * subStr=[resource substringToIndex:i];
        CGSize size=[subStr sizeWithAttributes:[NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName]];
        if(size.width>width)
            return i-1;
    }
    return (int)resource.length;
}

+(void)updateLessFlowModelImageOn:(UIImageView *)imageview withUrl:(NSString *)str defaultImage:(NSString *)imageStr
{
//    if ([WMUserDefault BoolValueForKey:@"safeFlowModel"]) {
//        Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
//        if ([r currentReachabilityStatus] != ReachableViaWiFi) {
//            if ([[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:str]) {
//                imageview.image = [[SDWebImageManager sharedManager].imageCache imageFromDiskCacheForKey:str];
//            }else{
//                imageview.image = [UIImage imageNamed:imageStr];
//            }
//        }else{
//            [imageview sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:imageStr]];
//        }
//    }else{
//        [imageview sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:imageStr]];
//    }
}

//+ (UserTopic *)novelDownloadStateWith:(NSInteger)nid
//{
//    if (![WMUserDefault arrayForKey:[NSString stringWithFormat:@"offLineNovel_%ld",[WMUserDefault longValueForKey:@"uid"]]]) {
//        return nil;
//    }else{
//        NSArray *array = [WMUserDefault arrayForKey:[NSString stringWithFormat:@"offLineNovel_%ld",[WMUserDefault longValueForKey:@"uid"]]];
//        if (array.count == 0) {
//            return nil;
//        }
//        NSInteger count = array.count;
//        
//        for (int i = 0; i < count; i++) {
//            UserTopic *topic = [array objectAtIndex:i];
//            if (topic.topic.topicId == nid) {
//                return topic;
//            }
//        }
//        return nil;
//    }
//}

//+(NSData *)responseDataRequest:(ASIHTTPRequest *)request Data:(NSData *)data
//{
//    NSData *currentData;
//    if ([request isResponseCompressed]) {// 响应是否被gzip压缩过？
//        currentData = [request responseData]; // 解压缩后的数据
//    }else{
//        currentData = data;
//    }
//    
//    return currentData;
//}

@end
