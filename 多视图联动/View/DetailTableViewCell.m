//
//  DetailTableViewCell.m
//  表格优化展示
//
//  Created by More Mocha on 16/11/9.
//  Copyright © 2016年 QivenDev. All rights reserved.
//

#import "DetailTableViewCell.h"
#import "UIImage+Extension.h"

@implementation DetailTableViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupUI];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    UIImage *iconImage = [UIImage imageNamed:@"icon_001"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:iconImage];
    imageView.frame = CGRectMake(10, 10, 60, 60);
    [iconImage qi_cornerImageWithSize:iconImage.size fillColor:[UIColor lightGrayColor] completion:^(UIImage *image) {
        imageView.image = image;
    }];
    self.layer.shouldRasterize      = true;
    self.layer.rasterizationScale   = [UIScreen mainScreen].scale;
    self.layer.drawsAsynchronously  = true;
    self.contentView.backgroundColor    = [UIColor lightGrayColor];
//    imageView.layer.cornerRadius    = 48;
//    imageView.layer.masksToBounds   = true;
    [self.contentView addSubview:imageView];
}

@end
