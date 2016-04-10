//
//  CartoonHeadView.m
//  Coupons
//
//  Created by Michael on 15/7/8.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CartoonHeadView.h"

#import "Utility.h"

@implementation CartoonHeadView

- (void)dealloc
{
    self.imageView = nil;
}

- (id)initWithFrame:(CGRect)frame withIdentifier:(NSString *)identfier
{
    self = [super initWithFrame:frame withIdentifier:identfier];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
