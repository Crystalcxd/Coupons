//
//  AppDelegate.m
//  Coupons
//
//  Created by Michael on 15/5/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "AppDelegate.h"

#import "HomeViewController.h"
#import "CouponsListViewController.h"

#import <AVOSCloud/AVOSCloud.h>

#import <CommonCrypto/CommonDigest.h>

#import <GoogleMobileAds/GoogleMobileAds.h>

#import <AdSupport/ASIdentifierManager.h>

@interface AppDelegate ()

@property (nonatomic , assign) BOOL showCouponsView;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.showCouponsView = NO;
         
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCoupons) name:@"showCoupons" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenCoupons) name:@"hidenCoupons" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCover) name:@"showCover" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenCover) name:@"hidenCover" object:nil];

    [AVOSCloud setApplicationId:@"z9h7085vvowmp7qgph2nqbb7uiospenjsbx8ynmbgwflj608"
                      clientKey:@"3htdkkj20gxoztbqbe9r5msw6hwuuql2yboa85uf9c3gm31u"];
    
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    [WXApi registerApp:WXAppId];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    [self mainView];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if([[url absoluteString] rangeOfString:WXAppId].location != NSNotFound){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return YES;
    }
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //#if __QQAPI_ENABLE__
    //    [QQApiInterface handleOpenURL:url delegate:(id)[QQAPIDemoEntry class]];
    //#endif
    if([[url absoluteString] rangeOfString:WXAppId].location != NSNotFound){
        return [WXApi handleOpenURL:url delegate:self];
    }
    else{
        return YES;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)mainView {
    // Homepage
    HomeViewController *homePageVC = [[HomeViewController alloc] init];
    homePageVC.navigationController.navigationBar.translucent = NO;
    MLNavigationController *navTofuHomeController = [[MLNavigationController alloc] initWithRootViewController:homePageVC];
    
    //Discover
    UIViewController *discoverVC = [[UIViewController alloc] init];
    discoverVC.view.backgroundColor = [UIColor yellowColor];
    discoverVC.navigationController.navigationBar.translucent = NO;
    MLNavigationController *navDiscoverController = [[MLNavigationController alloc] initWithRootViewController:discoverVC];
    
    // News
    UIViewController *newsVC = [[UIViewController alloc] init];
    newsVC.view.backgroundColor = [UIColor blueColor];
    newsVC.navigationController.navigationBar.translucent = NO;
    MLNavigationController *navNewsController = [[MLNavigationController alloc] initWithRootViewController:newsVC];
    
    RDVTabBarController *tabBarController = [[RDVTabBarController alloc] init];
    [tabBarController.tabBar setHeight:60];
    [tabBarController.tabBar setTranslucent:YES];
    tabBarController.tabBar.backgroundColor = [UIColor clearColor];
    
    [tabBarController setViewControllers:@[navTofuHomeController, navDiscoverController, navNewsController]];
    
    [self addCenterButtonWithImage:[UIImage imageNamed:@"home_ugc"] highlightImage:nil forTabBarViewController:tabBarController];

    [self configurationTabBar:tabBarController.tabBar];
    
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
}

- (void)addCenterButtonWithImage:(UIImage*)buttonImage highlightImage:(UIImage*)highlightImage forTabBarViewController:(RDVTabBarController *)tabBarViewController{
    MLNavigationController *navigationViewController = tabBarViewController.viewControllers[0];
    HomeViewController *viewController = navigationViewController.viewControllers[0];
    
    UIImageView *couponsBG = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH/3.0 + 2, 60)];
    couponsBG.tag = TABLEVIEW_BEGIN_TAG * 10;
    couponsBG.image = [UIImage imageNamed:@"bottom"];
    couponsBG.userInteractionEnabled = YES;
    [tabBarViewController.tabBar addSubview:couponsBG];
    couponsBG.hidden = YES;
    
    UIImageView *couponsView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH/6.0 - 15, 9, 30, 30)];
    couponsView.image = [UIImage imageNamed:@"hui"];
    [couponsBG addSubview:couponsView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(couponsView.frame) + 2, SCREENWIDTH/3.0, 12)];
    label.font = [UIFont systemFontOfSize:12.0];
    label.textColor = [UIColor whiteColor];
    label.text = @"优惠券";
    label.textAlignment = NSTextAlignmentCenter;
    [couponsBG addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backToRootView)];
    [couponsBG addGestureRecognizer:tap];
    
    UIButton *cartoonBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cartoonBtn.frame = CGRectMake(SCREENWIDTH/3.0, 0, SCREENWIDTH/3.0, 60);
    cartoonBtn.backgroundColor = [UIColor clearColor];
    cartoonBtn.tag = TABLEVIEW_BEGIN_TAG *20;
    cartoonBtn.highlighted = NO;
    [cartoonBtn addTarget:viewController action:@selector(goCartoonView:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabBarViewController.tabBar addSubview:cartoonBtn];
    
    UIButton *aboutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    aboutBtn.frame = CGRectMake(SCREENWIDTH/3.0*2, 0, SCREENWIDTH/3.0, 60);
    aboutBtn.backgroundColor = [UIColor clearColor];
    aboutBtn.tag = TABLEVIEW_BEGIN_TAG *30;
    aboutBtn.highlighted = NO;
    [aboutBtn addTarget:viewController action:@selector(goAboutView:) forControlEvents:UIControlEventTouchUpInside];
    
    [tabBarViewController.tabBar addSubview:aboutBtn];
    
    UIImageView *line = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_selected"]];
    line.frame = CGRectMake(SCREENWIDTH/3.0, 0, 1, 60);
    [tabBarViewController.tabBar addSubview:line];
    
    UIImageView *linetwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_selected"]];
    linetwo.frame = CGRectMake(SCREENWIDTH/3.0 * 2, 0, 1, 60);
    [tabBarViewController.tabBar addSubview:linetwo];
    
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    cover.tag = TABLEVIEW_BEGIN_TAG * 40;
    [tabBarViewController.tabBar addSubview:cover];
}

- (void)backToRootView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goBack" object:nil];
}

- (void)showCover
{
    RDVTabBarController *tabBarController = (RDVTabBarController *)self.window.rootViewController;
    
    UIView *cover = [tabBarController.tabBar viewWithTag:TABLEVIEW_BEGIN_TAG * 40];
    cover.hidden = NO;
}

- (void)hidenCover
{
    RDVTabBarController *tabBarController = (RDVTabBarController *)self.window.rootViewController;
    
    UIView *cover = [tabBarController.tabBar viewWithTag:TABLEVIEW_BEGIN_TAG * 40];
    cover.hidden = YES;
}

- (void)updateBottomBtn
{
    RDVTabBarController *tabBarController = (RDVTabBarController *)self.window.rootViewController;
    
    UIButton *cartoonBtn = (UIButton *)[tabBarController.tabBar viewWithTag:TABLEVIEW_BEGIN_TAG * 20];
    cartoonBtn.enabled = YES;
    
    UIButton *aboutBtn = (UIButton *)[tabBarController.tabBar viewWithTag:TABLEVIEW_BEGIN_TAG * 30];
    aboutBtn.enabled = YES;
}

- (void)showCoupons
{
    self.showCouponsView = YES;
    [self updateCouponsView];
}

- (void)hidenCoupons
{
    self.showCouponsView = NO;
    [self updateCouponsView];
}

- (void)updateCouponsView
{
    RDVTabBarController *tabBarController = (RDVTabBarController *)self.window.rootViewController;
    UIImageView *couponsBG = (UIImageView *)[tabBarController.tabBar viewWithTag:TABLEVIEW_BEGIN_TAG * 10];
    couponsBG.hidden = !self.showCouponsView;
}

- (void)configurationTabBar:(RDVTabBar *)tabBar {
    //设置  三个分类的  tabbaritem 选中和没选中下地背景图片 和  底图
    UIImage *finishedImageTofu = [UIImage imageNamed:@"bottom_selected"];
    UIImage *unfinishedImageTofu = [UIImage imageNamed:@"bottom"];
    
    NSArray *tabBarItemSelected = @[@"hui", @"manga",@"owl"];
    NSArray *tabBarItemNormal = @[@"hui", @"manga",@"owl"];
    NSArray *tabBarItemTitle = @[@"优惠券", @"漫画",@"关于我们"];

    NSInteger index = 0;
    for (RDVTabBarItem *item in tabBar.items) {
        [item setBackgroundSelectedImage:finishedImageTofu withUnselectedImage:unfinishedImageTofu];
        UIImage *selectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [tabBarItemSelected objectAtIndex:index]]];
        UIImage *unselectedimage = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [tabBarItemNormal objectAtIndex:index]]];
        [item setFinishedSelectedImage:selectedimage withFinishedUnselectedImage:unselectedimage];
        [item setTitle:[tabBarItemTitle objectAtIndex:index]];
        index++;
        NSLog(@"%ld", (long)index);
    }
}

#pragma mark - 微信分享
-(void)onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)onResp:(BaseResp*)resp
{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        NSString *strMsg = resp.errCode == 0 ? @"分享成功" : @"分享取消";
        [self alertWithTitle:@"" msg:strMsg];
    }
}

- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                          otherButtonTitles:nil];
    [alert show];
}

@end
