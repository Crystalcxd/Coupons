//
//  CartoonViewController.m
//  Coupons
//
//  Created by Michael on 15/6/15.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CartoonViewController.h"

#import "MptTableHeadView.h"
#import "CartoonHeadView.h"

#import "CartoonCell.h"

#import "DailyCartoon.h"

#import "WMUserDefault.h"

#import "UIImageView+WebCache.h"

@interface CartoonViewController ()<HeadViewDelegate,HeadViewDataSource,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) UIImageView *image;
@property (nonatomic , strong) MptTableHeadView *tableheadView;
@property (nonatomic , strong) NSMutableArray *array;
@property (nonatomic , strong) NSMutableDictionary *currentImageDic;

@end

@implementation CartoonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.array = [[NSMutableArray alloc] init];
    self.currentImageDic = [[NSMutableDictionary alloc] init];
    
    [self.array addObject:@"ad2"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(14, topdiatance, 42, 40)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton setAccessibilityLabel:NSLocalizedString(@"返回", nil)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftButton];

    
    self.tableheadView = [[MptTableHeadView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH / 375 * 200) Type:MptTableHeadViewOther];
    self.tableheadView.dataSource = self;
    self.tableheadView.delegate = self;
    
    [self updateHeadView];
    
    [self.view addSubview:self.tableheadView];
    
    UILabel *firstLine = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREENWIDTH, 0.7)];
    firstLine.backgroundColor = HexRGB(0xFC6865);
    [self.view addSubview:firstLine];
    
    UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREENWIDTH, SCREENHEIGHT - kStatusBarHeight)];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] init];
    table.tag = TABLEVIEW_BEGIN_TAG;
    [self.view addSubview:table];
    
    table.tableHeaderView = self.tableheadView;
    
    UIButton *upBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    upBtn.frame = CGRectMake(SCREENWIDTH - 38, SCREENHEIGHT - 88, 38, 44);
    [upBtn setImage:[UIImage imageNamed:@"cartoon_top"] forState:UIControlStateNormal];
    [upBtn addTarget:self action:@selector(scrollUpAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:upBtn];
    
}

- (void)loadLocalCache
{
    NSTimeInterval saveTime = [WMUserDefault floatValueForKey:kLastCartoonSaveTime];
    float timeInterval = [NSDate timeIntervalSinceReferenceDate]; //判断是否是刷新
    
    int time = (int)timeInterval;
    
    time = time/(kRefreshTimeInterval * 24);
    time = time%31;
    
    NSArray *array = nil;
    
    if (timeInterval - saveTime < kRefreshTimeInterval * 24 * 30 && [WMUserDefault objectValueForKey:@"CartoonList"]) {

        NSDictionary *dic = [WMUserDefault objectValueForKey:@"CartoonList"];

        DailyCartoon *cartoon = [dic objectForKey:time > 9 ? [NSString stringWithFormat:@"%d",time] : [NSString stringWithFormat:@"0%d",time]];
        
        
        [self.currentImageDic setValuesForKeysWithDictionary:cartoon.imageUrlDic];
        
//        array = [WMUserDefault arrayForKey:@"CartoonList"];
        
//        if (array.count > time) {
//            NSString *imgUrl = [array objectAtIndex:time];
//            [self.image sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
//        }
        
        UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_BEGIN_TAG];
        
        [table reloadData];

    }else{
        AVQuery *query = [AVQuery queryWithClassName:@"couponsCartoon1"];
        NSLog(@"%@",[query findObjects]);
        
        array = [query findObjects];
        
        NSMutableDictionary * dic = [self totalCartoonWith:array];
        
        NSLog(@"finish");
        
        [WMUserDefault setFloatVaule:timeInterval forKey:kLastCartoonSaveTime];
        
        [WMUserDefault setObjectValue:dic forKey:@"CartoonList"];

        DailyCartoon *cartoon = [dic objectForKey:time > 9 ? [NSString stringWithFormat:@"%d",time] : [NSString stringWithFormat:@"0%d",time]];
        
        
        [self.currentImageDic setValuesForKeysWithDictionary:cartoon.imageUrlDic];

        
        UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_BEGIN_TAG];
        
        [table reloadData];

//        if (array.count > time) {
//            [WMUserDefault setFloatVaule:timeInterval forKey:kLastCartoonSaveTime];
//            
//            
//            
//            AVObject *object = [array objectAtIndex:time];
//            
//            AVFile *file = [object objectForKey:@"image"];
//            [self.image sd_setImageWithURL:[NSURL URLWithString:file.url]];
//            
//            [self saveDataWith:array];
//        }
    }
    
}

- (NSMutableDictionary *)totalCartoonWith:(NSArray *)array
{
    NSMutableDictionary *totalDictionary = [[NSMutableDictionary alloc] init];
    
    NSInteger count = array.count;
    for (int i = 0; i < count; i++) {
        AVObject *object = [array objectAtIndex:i];
        AVFile *file = [object objectForKey:@"image"];
        
        NSNumber *height = [object objectForKey:@"height"];
        
        NSString *name = file.name;
        
        NSString *nameBody = [[name componentsSeparatedByString:@"."] objectAtIndex:0];
        
        NSString *indexName = [[nameBody componentsSeparatedByString:@"_"] objectAtIndex:0];
        
        NSString *subIndexName = @"0";
        
        if ([nameBody componentsSeparatedByString:@"_"].count > 1) {
            subIndexName = [[nameBody componentsSeparatedByString:@"_"] objectAtIndex:1];
        }else{
            subIndexName = @"1";
        }
        
        NSDictionary *cartoonPageImageDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:file.url,height, nil] forKeys:[NSArray arrayWithObjects:@"imageUrl", @"height", nil]];
        
        if ([totalDictionary objectForKey:indexName]) {
            DailyCartoon *cartoon = [totalDictionary objectForKey:indexName];
            
            NSMutableDictionary *cartoonImageDic = cartoon.imageUrlDic;
            
            [cartoonImageDic setObject:cartoonPageImageDic forKey:subIndexName];
            
        }else{
            DailyCartoon *cartoon = [[DailyCartoon alloc] init];
            cartoon.dayNumber = indexName;
            
            cartoon.imageUrlDic = [NSMutableDictionary dictionaryWithObject:cartoonPageImageDic forKey:subIndexName];
            
            [totalDictionary setObject:cartoon forKey:indexName];
        }
    }
    
    return totalDictionary;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.rdv_tabBarController setTabBarHidden:YES animated:NO];
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadLocalCache];
    });
}

- (void)saveDataWith:(NSArray *)array
{
    NSMutableArray *saveArray = [NSMutableArray array];
    
    NSInteger count = array.count;
    for (int i = 0; i < count; i++) {
        AVObject *object = [array objectAtIndex:i];
        
        AVFile *file = [object objectForKey:@"image"];
        [saveArray addObject:file.url];
    }
    
    [WMUserDefault setArray:saveArray forKey:@"CartoonList"];
}

- (void)goWebView
{
    [self goWebViewWith:@"http://weibo.com/u/1707252457"];
}

- (void)goWebViewWith:(NSString *)str
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

- (void)updateHeadView
{
    AVQuery *query = [AVQuery queryWithClassName:@"couponsAdImage"];
    NSLog(@"%@",[query findObjects]);
    
    NSMutableArray *array = [NSMutableArray arrayWithArray:[query findObjects]];
    if ([Utility isInValid:array]) {
        array = [NSMutableArray array];
    }

    if (array.count != 0) {
        [self.array removeAllObjects];
        [self.array addObjectsFromArray:array];
        
        [self.tableheadView reloadData];
    }
}

- (void)share:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    WXMediaMessage *message = [self wxShareSiglMessageScene:self.image.image];
    message.title = @"123";
    message.description = @"123";

    [self ShareWeixinLinkContent:message WXType:btn.tag - TABLEVIEW_BEGIN_TAG];
}

#pragma mark
#pragma mark TargetAction

- (void)scrollUpAction:(id)sender
{
    UITableView *table = (UITableView *)[self.view viewWithTag:TABLEVIEW_BEGIN_TAG];
    
    [table scrollRectToVisible:CGRectMake(0, 0, CGRectGetWidth(table.frame), CGRectGetHeight(table.frame)) animated:YES];
}

#pragma mark
#pragma mark headview datasource delegate
- (NSUInteger)numberOfItemFor:(MptTableHeadView *)scrollView {
    return [self.array count];
}

- (MptTableHeadCell *)cellViewForScrollView:(MptTableHeadView *)scrollView frame:(CGRect)frame AtIndex:(NSUInteger)index {
    static NSString *indentif = @"headCell";
    CartoonHeadView *cell = (CartoonHeadView *)[scrollView dequeueCellWithIdentifier:indentif];
    if (!cell) {
        cell = [[CartoonHeadView alloc] initWithFrame:frame withIdentifier:indentif];
    }
    id objc = nil;
    if (self.array.count > index) {
        objc = [self.array objectAtIndex:index];
    } else {
        return cell;
    }
    
    if ([objc isKindOfClass:[NSString class]]) {
        NSString *imgUrl = (NSString *)objc;
        cell.imageView.image = [UIImage imageNamed:imgUrl];
    }
    else if ([objc isKindOfClass:[AVObject class]]) {
        AVObject *object = (AVObject *)objc;
        
        AVFile *file = [object objectForKey:@"image"];
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:file.url]];
    }
    
    return cell;
}

- (void)tableHeadView:(MptTableHeadView *)headView didSelectIndex:(NSUInteger)index {
    if (self.array.count == 0) {
        return;
    }
    
    id objc = nil;
    if (self.array.count > index) {
        objc = [self.array objectAtIndex:index];
    } else {
        return;
    }
    
    if ([objc isKindOfClass:[NSString class]]) {
        return;
    }
    else if ([objc isKindOfClass:[AVObject class]]) {
        AVObject *object = (AVObject *)objc;
        
        NSString *str = [Utility safeStringWith:[object objectForKey:@"jumpUrl"]];
        if ([str isEqualToString:@""] || [str isEqualToString:@" "]) {
            return;
        }
        
        [self goWebViewWith:str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.currentImageDic allKeys].count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *articlIdentifier = @"article";
    static NSString *couponsIdentifier = @"coupons";
    
    if (indexPath.row == [self.currentImageDic allKeys].count) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:articlIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articlIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        cell.backgroundColor = HexRGB(0xffdde9);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 282 * SCREENWIDTH / 375.0, 282 *SCREENWIDTH / 375.0)];
        imageView.image = [UIImage imageNamed:@"544"];
        imageView.center = CGPointMake(SCREENWIDTH * 0.5, CGRectGetHeight(imageView.frame) * 0.5 + 34 * SCREENWIDTH / 375.0);
        
        [cell addSubview:imageView];
        
        UILabel *tipOne = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame) + 29 * SCREENWIDTH / 375.0, SCREENWIDTH, 20)];
        tipOne.text = @"看更多漫画，欢迎关注我的微博，";
        tipOne.textAlignment = NSTextAlignmentCenter;
        tipOne.textColor = HexRGB(0xff8c8c);
        tipOne.font = [UIFont systemFontOfSize:20];
        [cell addSubview:tipOne];
        
        UILabel *tipTwo = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tipOne.frame) + 10, SCREENWIDTH, 20)];
        tipTwo.text = @"谢谢大家！";
        tipTwo.textAlignment = NSTextAlignmentCenter;
        tipTwo.textColor = HexRGB(0xff8c8c);
        tipTwo.font = [UIFont systemFontOfSize:20];
        [cell addSubview:tipTwo];

        return cell;
    }
    
    NSDictionary *dic = [self.currentImageDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

    if (!dic) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:articlIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articlIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
    
    NSString *str = [dic objectForKey:@"imageUrl"];
    
//    Coupons *coupons = [self.array objectAtIndex:indexPath.row];
    
    CartoonCell *cell = [tableView dequeueReusableCellWithIdentifier:couponsIdentifier];
    if (cell == nil) {
        cell = [[CartoonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponsIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
//    cell.delegate = self;
    
    if (str.length != 0) {
        [cell configCellWith:str];
    }
    
//    if (indexPath.row%2 == 0) {
//        cell.backgroundColor = HexRGB(0xfcd4e3);
//    }else{
//        cell.backgroundColor = HexRGB(0xfce8e8);
//    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.currentImageDic allKeys].count) {
        
        return 446 * SCREENWIDTH / 375.0;
        
    }

    NSDictionary *dic = [self.currentImageDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row + 1]];

    NSNumber *number = [dic objectForKey:@"height"];
    
    return number.integerValue * 0.5 * SCREENWIDTHSCALE;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [self.currentImageDic allKeys].count) {
        [self goWebView];
    }
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
