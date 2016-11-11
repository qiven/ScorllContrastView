//
//  DetailCollectionViewCell.m
//  表格优化展示
//
//  Created by More Mocha on 16/11/8.
//  Copyright © 2016年 QivenDev. All rights reserved.
//

#import "DetailCollectionViewCell.h"
#import "DetailTableViewCell.h"
#import "TableViewSetting.h"

static NSString *detailTableViewCellId = @"detailTableViewCellId";

@interface DetailCollectionViewCell ()<UITableViewDataSource, UITableViewDelegate> {
    
    UITableView *_detailTableView;
}

@end

@implementation DetailCollectionViewCell

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
    _detailTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [_detailTableView registerClass:[DetailTableViewCell class] forCellReuseIdentifier:detailTableViewCellId];
    _detailTableView.dataSource     = self;
    _detailTableView.delegate       = self;
    _detailTableView.rowHeight      = rowHight;
    self.layer.shouldRasterize      = true;
    self.layer.rasterizationScale   = [UIScreen mainScreen].scale;
    self.layer.drawsAsynchronously  = true;
    [self.contentView addSubview:_detailTableView];
}


#pragma mark - TableView DataSoure

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailTableViewCellId forIndexPath:indexPath];
    return cell;
}


#pragma mark - TableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.01;
    }
    return heightForHeaderInSection;
}

@end
