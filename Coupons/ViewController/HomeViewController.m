//
//  HomeViewController.m
//  Coupons
//
//  Created by Michael on 15/5/29.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "HomeViewController.h"
#import "CouponsListViewController.h"
#import "CartoonViewController.h"
#import "AboutViewController.h"

#import "ToolBarPicker.h"

#import "BaiduMobAdView.h"

#import "Coupons.h"
#import "WMUserDefault.h"

@interface HomeViewController ()<BaiduMobAdViewDelegate,UIActionSheetDelegate>

@property (nonatomic , strong) UIScrollView *scrollview;
@property (nonatomic , strong) BaiduMobAdView *dmAdView;

@property (nonatomic , strong) ToolBarPicker *chooseView;

@property (nonatomic , strong) NSMutableArray *cityArray;
@property (nonatomic , strong) NSMutableArray *updateTimeArray;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.updateTimeArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"refresh" object:nil];
    
    UILabel *topline = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREENWIDTH, kLineHeight)];
    topline.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:0];
    [self.view addSubview:topline];
    
    
    self.dmAdView = [[BaiduMobAdView alloc] init];
    self.dmAdView.AdType = BaiduMobAdViewTypeBanner;
    self.dmAdView.frame = CGRectMake(0, 20, SCREENWIDTH, SCREENWIDTH / 320.0 * kBaiduAdViewSizeDefaultHeight);
    self.dmAdView.delegate = self;
    [self.view addSubview:self.dmAdView];
    
//    self.adView = [[AdMoGoView alloc] initWithAppKey:@"9155ba1a86334581a910b527d42ddd43" adType:AdViewTypeNormalBanner adMoGoViewDelegate:self autoScale:YES];
////    self.adView.backgroundColor = [UIColor grayColor];
//    // typedef enum {
//    // AdViewTypeUnknown = 0， //error
//    // AdViewTypeNormalBanner = 1， //e.g. 320 * 50 ; 320 * 48 iphone banner
//    // AdViewTypeLargeBanner = 2， //e.g. 728 * 90 ; 768 * 110 ipad only
//    // AdViewTypeMediumBanner = 3， //e.g. 468 * 60 ; 508 * 80 ipad only
//    // AdViewTypeRectangle = 4， //e.g. 300 * 250; 320 * 270 ipad only
//    // AdViewTypeSky = 5， //Don't support
//    // AdViewTypeFullScreen = 6， //iphone full screen ad
//    // AdViewTypeVideo = 7， //Don't support
//    // AdViewTypeiPadNormalBanner = 8， //ipad use iphone banner 
//    // } AdViewType; 
//    self.adView.frame = CGRectMake(0, CGRectGetMaxY(topline.frame), 320, 48);
//    [self.view addSubview:self.adView];
    
    self.scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, SCREENWIDTH / 320.0 * kBaiduAdViewSizeDefaultHeight + 20, SCREENWIDTH, SCREENHEIGHT - kBottomViewHeight - SCREENWIDTH / 320.0 * kBaiduAdViewSizeDefaultHeight - 20)];
    [self.scrollview setContentSize:CGSizeMake(SCREENWIDTH, 30 * 6 + 68 * 5)];
    self.scrollview.backgroundColor = HexRGB(0xff99bf);
    [self.view addSubview:self.scrollview];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenCitySelect)];
    [self.scrollview addGestureRecognizer:tap];
    
    for (int i = 0; i < 5; i++) {
        UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH * 0.5 - 123, 30 + i * (30 + 68), 247, 68)];
        itemView.clipsToBounds = YES;
        itemView.layer.cornerRadius = 8.0;
        itemView.backgroundColor = HexRGB(0xfdacca);
        itemView.tag = TABLEVIEW_BEGIN_TAG + i;
        [self.scrollview addSubview:itemView];
        
        UIImage *image = nil;
        switch (i) {
            case 0:
                image = [UIImage imageNamed:@"kfc"];
                break;
            case 1:
                image = [UIImage imageNamed:@"mac"];
                break;
            case 2:
                image = [UIImage imageNamed:@"zgf"];
                break;
            case 3:
                image = [UIImage imageNamed:@"yhdw"];
                break;
            case 4:
                image = [UIImage imageNamed:@"dicos"];
                break;

            default:
                break;
        }
        UIImageView *shopImage = [[UIImageView alloc] initWithImage:image];
        shopImage.center = CGPointMake(CGRectGetWidth(itemView.frame) * 0.5, CGRectGetHeight(itemView.frame) * 0.5);
        
        [itemView addSubview:shopImage];
        
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpView:)];
        [itemView addGestureRecognizer:recognizer];
    }
    
    AVQuery *query = [AVQuery queryWithClassName:@"dksCity"];

    self.cityArray = [NSMutableArray arrayWithArray:[query findObjects]];
    
    self.chooseView = [[ToolBarPicker alloc] initWithArray:self.cityArray frame:CGRectMake(0, CGRectGetHeight(self.view.frame)-kBottomViewHeight, SCREENWIDTH, 0)];
    [self.view addSubview:self.chooseView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.dmAdView start];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.rdv_tabBarController setTabBarHidden:NO animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenCoupons" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidenCover" object:nil];
    [self updateItemViewColorWith:-1];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.dmAdView close];
}

- (void)updateItemViewColorWith:(NSInteger)tag
{
    for (UIView *view in self.scrollview.subviews) {
        if (view.tag >= TABLEVIEW_BEGIN_TAG) {
            if (view.tag - TABLEVIEW_BEGIN_TAG == tag) {
                view.backgroundColor = HexRGB(0xed9595);
            }else{
                view.backgroundColor = HexRGB(0xfdacca);
            }
        }
    }
}

-(void)jumpView:(UITapGestureRecognizer *)recognizer
{
    [self.chooseView cancle];
    
    UIView *view = recognizer.view;
    
    [self updateItemViewColorWith:view.tag - TABLEVIEW_BEGIN_TAG];
    
    if (view.tag - TABLEVIEW_BEGIN_TAG == 4) {
        [self showActionSheet];
        return;
    }
    
    NSString *dictionaryName = @"";
    
    switch (view.tag - TABLEVIEW_BEGIN_TAG) {
        case 0:
            dictionaryName = @"kfc";
            break;
        case 1:
            dictionaryName = @"mac";
            break;
        case 2:
            dictionaryName = @"zgk";
            break;
        case 3:
            dictionaryName = @"yhdw";
            break;
        default:
            dictionaryName = @"kfc";
            break;
    }
    
    [self loadLocalCacheWithKey:dictionaryName];
}

- (void)loadLocalCacheWithKey:(NSString *)key
{
    NSTimeInterval saveTime = [WMUserDefault floatValueForKey:[NSString stringWithFormat:kLastCouponsSaveTime,key]];

    float timeInterval = [NSDate timeIntervalSinceReferenceDate]; //判断是否是刷新
    
    NSArray *array = nil;
    
    if (timeInterval - saveTime < kRefreshTimeInterval * 24 && [WMUserDefault arrayForKey:[NSString stringWithFormat:kCouponsListData,key]].count != 0) {
        array = [WMUserDefault arrayForKey:[NSString stringWithFormat:kCouponsListData,key]];
        
        CouponsListViewController *CouponsVC = [[CouponsListViewController alloc] initWithArray:[NSMutableArray arrayWithArray:array]];
        [self.navigationController pushViewController:CouponsVC animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCoupons" object:nil];
    }else{
        AVQuery *query = [AVQuery queryWithClassName:key];
        NSLog(@"%@",[query findObjects]);
        
        NSArray *array = [query findObjects];
        
        NSMutableArray *saveArray = [NSMutableArray array];
        
        if (array.count != 0) {
            NSInteger count = array.count;
            
            for (int i = 0; i < count; i++) {
                AVObject *object = [array objectAtIndex:i];
                
                Coupons *coupons = [Coupons parseObject:object];
                if (coupons) {
                    [saveArray addObject:coupons];
                }
            }
        }
        
        [WMUserDefault setArray:saveArray forKey:[NSString stringWithFormat:kCouponsListData,key]];
        [WMUserDefault setFloatVaule:timeInterval forKey:[NSString stringWithFormat:kLastCouponsSaveTime,key]];
        
        CouponsListViewController *CouponsVC = [[CouponsListViewController alloc] initWithArray:saveArray];
        [self.navigationController pushViewController:CouponsVC animated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showCoupons" object:nil];
    }
}

-(void)hidenCitySelect
{
    [self.chooseView cancle];
}

-(void)addview{
    if (self.cityArray.count != 0) {
        [self.chooseView viewOpen];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有城市信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void)showActionSheet
{
    if (self.cityArray.count != 0) {
//        NSMutableArray *array = [self nameArrayFrom:self.cityArray];
//        
//        // 创建时不指定按钮
//        
//        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil   delegate:self
//                                
//                                                  cancelButtonTitle:nil
//                                
//                                             destructiveButtonTitle:nil
//                                
//                                                  otherButtonTitles:nil];
//        
//        // 逐个添加按钮（比如可以是数组循环）
//        
//        NSInteger count = [array count];
//        
//        for (int i = 0; i < count; i++) {
//            NSString *str = [array objectAtIndex:i];
//            
//            [sheet addButtonWithTitle:str];
//        }
//        
//        // 同时添加一个取消按钮
//        
//        [sheet addButtonWithTitle:@"取消"];
//        
//        // 将取消按钮的index设置成我们刚添加的那个按钮，这样在delegate中就可以知道是那个按钮 
//        
//        // NB - 这会导致该按钮显示时有黑色背景 
//        
//        sheet.cancelButtonIndex = sheet.numberOfButtons-1; 
//        [sheet showInView:self.view];
        [self.chooseView viewOpen];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"没有城市信息！" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(NSMutableArray *)nameArrayFrom:(NSMutableArray *)array
{
    NSMutableArray *nameArray = [NSMutableArray array];
    if (array.count == 0) {
        return nameArray;
    }
    
    NSInteger count = array.count;
    
    for (int i = 0; i < count; i++) {
        AVObject *object = [array objectAtIndex:i];
        NSString *str = [Utility safeStringWith:[object objectForKey:@"city"]];
        if (![str isEqualToString:@""]) {
            [nameArray addObject:str];
        }
    }
    
    return nameArray;
}

-(void)refresh
{
    if (self.cityArray.count <= self.chooseView.tabletag) {
        return;
    }
    AVObject *object = [self.cityArray objectAtIndex:self.chooseView.tabletag];
    NSString *cityStr = [object objectForKey:@"cityKey"];
    
    [self loadLocalCacheWithKey:cityStr];
}

-(void)goCartoonView:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCover" object:nil];
    
    CartoonViewController *cartoonVC = [[CartoonViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:cartoonVC animated:YES];
}

-(void)goAboutView:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showCover" object:nil];
    
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:aboutVC animated:YES];
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

@end