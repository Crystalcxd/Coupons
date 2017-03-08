//
//  AppDelegate.h
//  Coupons
//
//  Created by Michael on 15/5/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <RDVTabBarController/RDVTabBarController.h>
#import <RDVTabBarController/RDVTabBarItem.h>
#import <RDVTabBarController/RDVTabBar.h>
#import "MLNavigationController.h"

#import "WXApi.h"

#define WXAppId @"wxe3f292c76284bbd8"
#define BaiDuAppId @"f51c1ca5"

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

