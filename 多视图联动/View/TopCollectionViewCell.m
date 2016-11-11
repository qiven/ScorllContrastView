//
//  TopCollectionViewCell.m
//  表格优化展示
//
//  Created by More Mocha on 16/11/8.
//  Copyright © 2016年 QivenDev. All rights reserved.
//

#import "TopCollectionViewCell.h"
#import "CircleProgressView.h"
#import "TableViewSetting.h"

@implementation TopCollectionViewCell {
    UILabel *_countLabel;
    CircleProgressView *_autoCalculateCircleView;
}

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

- (void)setupUI
{
    _autoCalculateCircleView = [[CircleProgressView alloc] initWithFrame:CGRectMake(10, 30, 50, 50)];
    // Auto calculate radius
    int arcProgress = (arc4random() % 100)+1;
    [_autoCalculateCircleView drawCircleWithPercent:arcProgress
                                               duration:1
                                              lineWidth:8
                                              clockwise:YES
                                                lineCap:kCALineCapRound
                                              fillColor:[UIColor clearColor]
                                            strokeColor:[UIColor redColor]
                                         animatedColors:nil];
    [self.contentView addSubview:_autoCalculateCircleView];
    [_autoCalculateCircleView startAnimation];
    
    _countLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 45, 40, 20)];
    [_countLabel setFont:[UIFont systemFontOfSize:12]];
    [_countLabel setTextColor:[UIColor darkGrayColor]];
    [_countLabel setText:[NSString stringWithFormat:@"%zd%%", arcProgress]];
    [self.contentView addSubview:_countLabel];
    self.layer.shouldRasterize = true;
    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.layer.drawsAsynchronously = true;
}

@end
