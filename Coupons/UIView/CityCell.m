//
//  CityCell.m
//  Coupons
//
//  Created by Michael on 15/7/9.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CityCell.h"

#import "Utility.h"

@interface CityCell ()

@property (nonatomic , strong) UILabel *cityLabel;

@end

@implementation CityCell

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
        self.cityLabel.textColor = HexRGB(0x787778);
        self.cityLabel.textAlignment = NSTextAlignmentCenter;
        self.cityLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:self.cityLabel];
    }
    return self;
}

- (void)configCellWith:(AVObject *)object
{
    self.cityLabel.text = [Utility safeStringWith:[object objectForKey:@"city"]];
}

- (void)updateSelectState:(BOOL)selected
{
    if (selected) {
        self.cityLabel.textColor = kNavBGColor;
    }else{
        self.cityLabel.textColor = [UIColor blackColor];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
