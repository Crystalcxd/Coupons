//
//  ToolBarPicker.h
//  WeMedia
//
//  Created by Diaobaola on 14-7-8.
//  Copyright (c) 2014年 Tap Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ToolBarPicker : UIView<UITableViewDelegate,UITableViewDataSource>{
//    UIView *toolBar;
    UITableView *tableview;
    NSArray *tableArray;
    CGRect closeView;
    CGRect openView;
    BOOL isOpen;
    NSInteger tabletag;
}
@property (nonatomic, retain) UITableView *tableview;
@property (nonatomic, retain) NSArray *tableArray;
@property (nonatomic, assign) NSInteger tabletag;
@property BOOL isOpen;

-(id)initWithArray:(NSArray *)array frame:(CGRect)frame;
-(void)viewOpen;
-(void)viewClose;

-(void)cancle;
-(void)done;

@end
