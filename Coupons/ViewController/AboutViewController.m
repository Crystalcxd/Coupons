//
//  AboutViewController.m
//  Coupons
//
//  Created by Michael on 15/6/15.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
        
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(14, topdiatance, 60, 40)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton setAccessibilityLabel:NSLocalizedString(@"返回", nil)];
    [leftButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [leftButton addTarget:self action:@selector(left:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:leftButton];
    
    UILabel *firstLine = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREENWIDTH, 0.7)];
    firstLine.backgroundColor = RGBA(252, 63, 56, 1);
    [self.view addSubview:firstLine];

    UILabel *info = [[UILabel alloc] initWithFrame:CGRectMake(0, kStatusBarHeight, SCREENWIDTH, 54)];
    info.textAlignment = NSTextAlignmentCenter;
    info.text = @"商务合作       qq：1259959450";
    info.font = [UIFont systemFontOfSize:14.0];
    info.textColor = HexRGB(0x787778);
    [self.view addSubview:info];
    
    UIView *bottomBG = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 60, SCREENWIDTH, 60)];
    bottomBG.backgroundColor = HexRGB(0xed9595);
    [self.view addSubview:bottomBG];
    
    UIImageView *logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"company"]];
    logo.frame = CGRectMake(0, 0, 221, 36);
    logo.center = CGPointMake(CGRectGetWidth(bottomBG.frame) * 0.5, CGRectGetHeight(bottomBG.frame) * 0.5);
    [bottomBG addSubview:logo];
    
    UILabel *slogan = [[UILabel alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 120, SCREENWIDTH, 60)];
    slogan.textAlignment = NSTextAlignmentCenter;
    slogan.text = @"每天为生活带来一点快乐";
    slogan.font = [UIFont systemFontOfSize:14.0];
    slogan.textColor = HexRGB(0x787778);
    [self.view addSubview:slogan];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.rdv_tabBarController setTabBarHidden:YES animated:NO];
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
