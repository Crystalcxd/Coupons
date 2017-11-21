//
//  CouponsCell.m
//  Coupons
//
//  Created by Michael on 15/6/5.
//  Copyright (c) 2015年 Michael. All rights reserved.
//

#import "CouponsCell.h"

#import "Utility.h"

#import "UIImageView+WebCache.h"

#import "ASIHTTPRequest.h"

#define kOffsetX 10
#define kOffsetY 13

#define kImageWidth 145
#define kImageHeight 155

@interface CouponsCell ()

@property (nonatomic , strong) UIImageView *picture;
@property (nonatomic , strong) UILabel *content;
@property (nonatomic , strong) UILabel *price;
@property (nonatomic , strong) UILabel *date;

@property (nonatomic , strong) Coupons *coupons;

@property (nonatomic , strong) ASIHTTPRequest *request;
@property (nonatomic , strong) NSMutableData *jsondata;

@property (nonatomic , assign) BOOL shareState;

@property (nonatomic , strong) UIImage *image;

@end

@implementation CouponsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.shareState = NO;
        
        self.clipsToBounds = YES;
        
        self.jsondata = [[NSMutableData alloc] init];
        
        self.picture = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 145, 120)];
        self.picture.userInteractionEnabled = YES;
        self.picture.clipsToBounds = YES;
        [self addSubview:self.picture];
        
        self.content = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.picture.frame) + kOffsetX, kOffsetY, SCREENWIDTH - CGRectGetMaxX(self.picture.frame) - kOffsetX, 20)];
        self.content.backgroundColor = [UIColor clearColor];
        self.content.font = [UIFont systemFontOfSize:14.0];
        self.content.numberOfLines = 0;
        [self addSubview:self.content];
        
        self.price = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.content.frame), 82, CGRectGetWidth(self.content.frame), 16)];
        self.price.font = [UIFont systemFontOfSize:16.0];
        [self addSubview:self.price];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.content.frame), CGRectGetMaxY(self.price.frame) + 10, CGRectGetWidth(self.content.frame), 12)];
        self.date.textColor = HexRGB(0x4a4a4a);
        self.date.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:self.date];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(SCREENWIDTH - kOffsetX - 44, 105, 44, 38);
        [shareBtn setImage:[UIImage imageNamed:@"weixin_coupons"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(shareCoupons) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:shareBtn];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showImage)];
        [self.picture addGestureRecognizer:tap];
    }
    return self;
}

- (void)shareCoupons
{
    if (self.picture.image) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(shareWith:)]) {
            [self.delegate shareWith:self.picture.image];
        }
    }else{
        self.shareState = YES;
        [self loadImage];
    }
}

- (void)showImage
{
    if (self.image) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(showBigImageWith:)]) {
            [self.delegate showBigImageWith:self.image];
        }
    }else{
        self.shareState = NO;
        [self loadImage];
    }
}

- (void)loadImage
{
    self.request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:self.coupons.imgUrl]];
    NSLog(@"favorite url:%@",self.request.url.absoluteString);
    self.request.tag = 105;
    [self.request setDelegate:self];
    [self.request startAsynchronous];
}

#pragma mark - ASIHTTPREQUEST
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 105){
        UIImage *avatar_image = [UIImage imageWithData:self.jsondata];
        self.image = avatar_image;
        if (avatar_image != nil) {
            if (self.shareState) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(shareWith:)]) {
                    [self.delegate shareWith:avatar_image];
                }
            }else{
                if (self.delegate && [self.delegate respondsToSelector:@selector(showBigImageWith:)]) {
                    [self.delegate showBigImageWith:avatar_image];
                }
            }
        }
    }
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if(request.tag == 105){
        [self.jsondata appendData:data];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"%@",[request.error description]);
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
    if(request.tag == 105){
        [self.jsondata setData:nil];
    }
}

- (void)configCellWith:(Coupons *)coupons
{
    if (coupons) {
        self.coupons = coupons;
        
        [self.picture sd_setImageWithURL:[NSURL URLWithString:coupons.imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (![Utility isInValid:image]) {
                self.image = image;
                
                NSLog(@"%@ %f %f",image,image.size.width,image.size.height);
                
                CGFloat height = 145.0/image.size.width*image.size.height;
                
                CGRect frame = self.picture.frame;
                
                frame.size.height = height;
                
                self.picture.frame = frame;
            }
        }];
        
        CGSize titleSize;
        CGSize standardSize;
        CGFloat titleHeight = 0.0f;
        
        titleSize = [coupons.content boundingRectWithSize:CGSizeMake(SCREENWIDTH - 3*kOffsetX - kImageWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.content.font} context:nil].size;
        standardSize = [NSLocalizedString(@"All.standard.string", nil) boundingRectWithSize:CGSizeMake(SCREENWIDTH - 3*kOffsetX - kImageWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.content.font} context:nil].size;
        
        if (titleSize.height > standardSize.height *3 ) {
            titleHeight = standardSize.height *3;
        }else{
            titleHeight = titleSize.height;
        }

        self.content.text = [Utility safeStringWith:coupons.content];
        CGRect frame = self.content.frame;
        frame.size.height = titleHeight;
        self.content.frame = frame;
        
        self.price.text = [Utility safeStringWith:coupons.price];
        
        self.date.text = [Utility safeStringWith:coupons.date];
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
