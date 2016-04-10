//
//  CouponsListViewController.m
//  Coupons
//
//  Created by Michael on 15/6/5.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CouponsListViewController.h"

#import "CouponsCell.h"

#import "BaiduMobAdView.h"

#import "WMUserDefault.h"

#import "Coupons.h"

#import "AppDelegate.h"

@interface CouponsListViewController ()<UITableViewDataSource,UITableViewDelegate,CouponsCellDelegate,BaiduMobAdViewDelegate>

@property (nonatomic , strong) NSMutableArray *array;

@property (nonatomic , strong) BaiduMobAdView *adView;

@end

@implementation CouponsListViewController

- (id)initWithArray:(NSMutableArray *)array
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.array = array;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(left:) name:@"goBack" object:nil];
    
    UILabel *topline = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, kLineHeight)];
    topline.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0];
    [self.view addSubview:topline];

    self.adView = [[BaiduMobAdView alloc] init];
    self.adView.AdType = BaiduMobAdViewTypeBanner;
    self.adView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH / 320.0 * kBaiduAdViewSizeDefaultHeight);
    self.adView.delegate = self;

    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topline.frame), SCREENWIDTH, SCREENHEIGHT - topdiatance - kBottomViewHeight)];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [table reloadData];
    
    table.tableHeaderView = self.adView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.rdv_tabBarController setTabBarHidden:NO animated:NO];
    
    [self.adView start];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.adView close];
}
#pragma mark CouponsCellDelegate
- (void)shareWith:(UIImage *)image
{
    WXMediaMessage *message = [self wxShareSiglMessageScene:image];
    message.title = @"123";
    message.description = @"123";
    
    [self ShareWeixinLinkContent:message WXType:0];
}

- (void)showBigImageWith:(UIImage *)image
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIView *bgView = [[UIView alloc] initWithFrame:appDelegate.window.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.8];
    bgView.tag = TABLEVIEW_BEGIN_TAG * 50;
    [appDelegate.window addSubview:bgView];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
    [bgView addSubview:imageview];
    
    CGFloat height = SCREENWIDTH/image.size.width*image.size.height;
    
    CGRect frame = imageview.frame;
    
    frame.size.width = SCREENWIDTH;
    frame.size.height = height;
    
    imageview.frame = frame;
    
    imageview.center = CGPointMake(CGRectGetWidth(bgView.frame) * 0.5, CGRectGetHeight(bgView.frame) * 0.5);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeBigImage)];
    [bgView addGestureRecognizer:tap];
}

- (void)removeBigImage {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIView *view = [appDelegate.window viewWithTag:TABLEVIEW_BEGIN_TAG * 50];
    
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha = 0;
    }                completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}

#pragma mark
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *articlIdentifier = @"article";
    static NSString *couponsIdentifier = @"coupons";

    if (indexPath.row >= [self.array count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:articlIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articlIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    Coupons *coupons = [self.array objectAtIndex:indexPath.row];
    
    CouponsCell *cell = [tableView dequeueReusableCellWithIdentifier:couponsIdentifier];
    if (cell == nil) {
        cell = [[CouponsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponsIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.delegate = self;
    
    [cell configCellWith:coupons];
    
    if (indexPath.row%2 == 0) {
        cell.backgroundColor = HexRGB(0xfcd4e3);
    }else{
        cell.backgroundColor = HexRGB(0xfce8e8);
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    
    if (indexPath.row >= [self.array count]) {
        return height;
    }
    
    return 155;
}

#pragma mark
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark BaiduMobAdViewDelegate
- (NSString *)publisherId
{
    return BaiDuAppId;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
