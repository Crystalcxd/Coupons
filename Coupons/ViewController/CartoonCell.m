//
//  CartoonCell.m
//  Coupons
//
//  Created by Michael on 16/3/13.
//  Copyright © 2016年 Michael. All rights reserved.
//

#import "CartoonCell.h"

#import "UIImageView+WebCache.h"

#import "Utility.h"

@interface CartoonCell ()

@property (nonatomic , strong) UIImageView *image;

@end

@implementation CartoonCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
        
        [self addSubview:self.image];
    }
    
    return self;
}

- (void)configCellWith:(NSString *)imgUrl
{
    __block CGFloat height = 0.0f;

    __weak typeof(self) weakSelf = self;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        __strong typeof(weakSelf) strongSelf = weakSelf;//加一下强引用，避免weakSelf被释放掉
        
        if (image) {
            height = image.size.height * SCREENWIDTH / image.size.width;
        }
        
        strongSelf.image.image = image;
        
        CGRect frame = strongSelf.image.frame;
        frame.size.height = height;
        strongSelf.image.frame = frame;
        
        frame = strongSelf.frame;
        frame.size.height = height;
        strongSelf.frame = frame;
    }];
}

+ (CGFloat)calculateCellHeightWith:(NSString *)imgUrl
{
    __block CGFloat height = 0.0f;
    
    UIImageView *imageview = [[UIImageView alloc] init];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 处理耗时操作的代码块...
        [imageview sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            height = image.size.height * SCREENWIDTH / image.size.width;
            
        }];
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            //回调或者说是通知主线程刷新，

        });
        
    });
    
    
    return height;
}

@end
