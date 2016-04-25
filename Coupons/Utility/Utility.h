//
//  Utility.h
//  WeMedia
//
//  Created by Kyle on 14-4-1.
//  Copyright (c) 2014年 Tap Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HexRGB(hexRGB) [UIColor colorWithRed:((float)((hexRGB & 0xFF0000) >> 16))/255.0 green:((float)((hexRGB & 0xFF00) >> 8))/255.0 blue:((float)(hexRGB & 0xFF))/255.0 alpha:1.0]
#define radians(x) ((x)*M_PI/180.0)
#define kNavBGColor HexRGB(0xff6e70)
#define CANAL @"App Store"
#define APP_STORE_ID @"902862193"

#define kDesFont [UIFont fontWithName:@"Helvetica" size:14]

#define kNavBtnDiatanceY 7
#define kBottomViewHeight 60
#define kStatusBarHeight 64
#define topdiatance 20
#define kLineHeight 0.7
//1.竖排留状态栏
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define SCREENWIDTHSCALE [UIScreen mainScreen].bounds.size.width/375.0

#define TABLEVIEW_BEGIN_TAG 1000

#define DEBUGGING
#ifdef DEBUGGING
#define SAFE_RELEASE(Objc) [Objc release];
#else
#define SAFE_RELEASE(Objc) [Objc release];Objc = nil;
#endif

enum LogInType{
    LoginTypePhone = 0,
    LogInTypeSinaWeibo = 1,
    LogInTypeQQ = 2,
    LogInTypeEmail = 3
};

//NS_ENUM(NSInteger, ShareWayType)
//{
//    ShareWayTypeNone = 100,
//    ShareWayTypeWeibo,  //新浪微博
//    ShareWayTypeWeixin , //微信好友
//    ShareWayWeixinTimeline, //微信朋友圈
//    ShareWayTypeQQWeibo, //腾讯微博
//    ShareWayTypeSMS,//短信s
//    ShareWayTypeEmail, //邮箱
//    ShareWayTypeQQ, //QQ好友
//    ShareWayTypeQzone, //Qzone
//};

enum ContectType{
    ContectTypeNormal = 1,//普通内页
    ContectTypeUserTopic = 2//贴子内页
};

enum BindAccountType{
    BindAccountTypePhone = 1,
    BindAccountTypeEmail = 2,
    BindAccountTypeQQ = 3,
    BindAccountTypeWeibo = 4
};

enum TrendType{
    TrendTypeComment = 1,
    TrendTypeReply = 13,
    TrendTypeUGC = 6,
    TrendTypeCollect = 10
};

enum HomeObjectType{
    OBJECT_TYPE_ARTICLE = 1,
    OBJECT_TYPE_PICTURES = 2,
    OBJECT_TYPE_VIDEO = 3,
    OBJECT_TYPE_AUDIO = 4,
    OBJECT_TYPE_TOPIC = 5,
    OBJECT_TYPE_WORDS = 6,
    OBJECT_TYPE_COMMUNITY = 7,
    OBJECT_TYPE_ACTION = 8,
    OBJECT_TYPE_GIFS = 9,
    OBJECT_TYPE_COMMENT = 10,
    OBJECT_TYPE_ACTIVITY = 11,
    OBJECT_TYPE_USER = 12,
    OBJECT_TYPE_REPLY = 13,
    OBJECT_TYPE_LETTER = 14,
    OBJECT_TYPE_NOTIFY = 15,
    OBJECT_TYPE_USERS_TOPIC = 16,
    OBJECT_TYPE_LIVE_TOPIC = 17,
    OBJECT_TYPE_NOVEL = 18,
    OBJECT_TYPE_ANSWER = 19,
    OBJECT_TYPE_UNREAD_OBJ = 20,
    OBJECT_TYPE_LOGIN_INFO = 21,
    OBJECT_TYPE_NOVEL_DETAILS = 22,
    OBJECT_TYPE_LOTTERY = 23,
    OBJECT_TYPE_WEBVIEW = 24,
    OBJECT_TYPE_SNS = 25,
    OBJECT_TYPE_ALARM = 26,
    OBJECT_TYPE_EASY_WEBVIEW = 27,
    OBJECT_TYPE_NOVEL_INFO = 28,
    OBJECT_TYPE_NOVEL_REVIEW = 29,
    OBJECT_TYPE_FAVORITE = 32,
    OBJECT_TYPE_COMMON_COMMENT = 33,
    OBJECT_TYPE_ROUTE = 34,
    OBJECT_TYPE_WALLPAPER = 35,
    OBJECT_TYPE_RINGTONE = 36,
    OBJECT_TYPE_ALBUMS = 39

};

enum HomeOPType{
    OP_TYPE_COMMENT = 1,
    OP_TYPE_SHARE_CONTENT = 2,
    OP_TYPE_GROOVE = 3,
    OP_TYPE_BIND_SOCIAL = 4,
    OP_TYPE_SHARE_APP = 5,
    OP_TYPE_UGC = 6,
    OP_TYPE_INVITE = 7,
    OP_TYPE_USE_SCORE = 8,
    OP_TYPE_SUB_SCORE = 9,
    OP_TYPE_FAVORITE = 10,
    OP_TYPE_REPLY = 13,
    OP_TYPE_SEND_LETTER = 14,
    OP_TYPE_REPLY_REPLY = 15,
    OP_TYPE_FOLLOWING = 16,
    OP_TYPE_REVIEW = 17,
    OP_TYPE_REVIEW_COMMENT = 18,
    OP_TYPE_CHANGE_SCORE = 19,
    OP_TYPE_LOGIN = 21,
    OP_TYPE_LOGOUT = 22,
    OP_TYPE_INVITE_ACCEPT = 23
};

@interface Utility : NSObject

NSUInteger DeviceSystemMajorVersion();

+(NSString *)convertToString:(NSTimeInterval)timeInterval formatter:(NSDateFormatter *)dateFormatter;
//时间距离
+(NSString *)dateStringWith:(NSInteger)time;
//聊天时间
+(NSString *)chatTimeStringWith:(NSInteger)time;
//时间字符串
+(NSString *)dateStringFrom:(NSDate *)date;
//***********************数据安全处理
+(NSInteger)safeIntValueWith:(id)objc;
+(BOOL)safeBoolValueWith:(id)objc;
+(NSString *)safeStringWith:(id)objc;
+(BOOL)isInValid:(id)objc;
+(BOOL)emptyString:(NSString *)str;
//打星
+(NSString *)starDesWith:(NSString *)star;
+(UIColor *)colorWith:(NSString *)star;
//UILabel行间距
+(int)getRightIndex:(NSString*)resource forWidth:(float)width withFont:(UIFont*)font;
//省流量
+(void)updateLessFlowModelImageOn:(UIImageView *)imageview withUrl:(NSString *)str defaultImage:(NSString *)imageStr;

//+(UserTopic *)novelDownloadStateWith:(NSInteger)nid;

//+(NSData *)responseDataRequest:(ASIHTTPRequest *)request Data:(NSData *)data;

@end
