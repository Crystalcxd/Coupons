//
//  ToolBarPicker.m
//  WeMedia
//
//  Created by Diaobaola on 14-7-8.
//  Copyright (c) 2014年 Tap Tech. All rights reserved.
//

#import "ToolBarPicker.h"
#import "Utility.h"

#import "CityCell.h"

#import <AVOSCloud/AVOSCloud.h>

@implementation ToolBarPicker

@synthesize tableview,tableArray,isOpen,tabletag;

-(id) initWithArray:(NSArray *)array frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.tabletag = -1;
        
        isOpen = NO;
        closeView = self.frame;
        openView = CGRectMake(closeView.origin.x, closeView.origin.y-200, closeView.size.width, 200);
        [self setClipsToBounds:YES];
        [self setBackgroundColor:[UIColor whiteColor]];
        
        tableArray = [[NSArray alloc] initWithArray:array];
        tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 200)];
        [tableview setBackgroundColor:HexRGB(0xFFDDE9)];
        tableview.delegate = self;
        tableview.dataSource = self;
        [self addSubview:tableview];
    }
    return self;
}

-(void)viewOpen{
    isOpen = YES;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];
    [self setFrame:openView];
    [UIView commitAnimations];
}

-(void)viewClose{
    isOpen = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration:0.2];
    [self setFrame:closeView];
    [UIView commitAnimations];
}

#pragma mark
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return tableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *articlIdentifier = @"article";
    static NSString *couponsIdentifier = @"coupons";
    
    if (indexPath.row >= [self.tableArray count]) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:articlIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:articlIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
        }
        return cell;
    }
    
    AVObject *object = [self.tableArray objectAtIndex:indexPath.row];
    
    CityCell *cell = [tableView dequeueReusableCellWithIdentifier:couponsIdentifier];
    if (cell == nil) {
        cell = [[CityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:couponsIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    [cell configCellWith:object];
    if (indexPath.row == self.tabletag) {
        [cell updateSelectState:YES];
    }else{
        [cell updateSelectState:NO];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

#pragma mark
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.tabletag = indexPath.row;
    [self.tableview reloadData];
    [self performSelector:@selector(done) withObject:nil afterDelay:0.5];
}

-(void)done{
//    [self viewClose];
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    NSNotification *notification = [NSNotification notificationWithName:@"refresh" object:nil];
    [notificationCenter postNotification:notification];
}

- (void)cancle{
    [self viewClose];
}

@end
