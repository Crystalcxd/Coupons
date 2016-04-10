//
//  RootViewController.h
//  Coupons
//
//  Created by Michael on 15/6/3.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#import <AVOSCloud/AVOSCloud.h>

#import "Utility.h"

@interface RootViewController : UIViewController

- (void)left:(id)sender;

- (void)ShareWeixinLinkContent:(WXMediaMessage *)message WXType:(NSInteger)scene;

- (WXMediaMessage *)wxShareSiglMessageScene:(UIImage *)image;

@end
