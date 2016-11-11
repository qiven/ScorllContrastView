//
//  ViewController.m
//  多视图联动
//
//  Created by More Mocha on 16/11/11.
//  Copyright © 2016年 QivenDev. All rights reserved.
//

#import "ViewController.h"
#import "TopCollectionViewCell.h"
#import "DetailCollectionViewCell.h"
#import "TableViewSetting.h"
#import "SVProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kAverageTableViewWidth (kScreenWidth / 3)   // 子视图宽度
#define kTopCarIconListViewHeight 170               // 头部视图高度

typedef enum : NSUInteger {
    TitleTableViewTag       =   1,
    DetailScrollViewTag     =   2,
    TopIconListViewTag      =   3,
} ScrollViewTag;

static SystemSoundID shake_sound_yao_id         =   0;    // 声音
static NSString *titleTableViewCellID           =   @"titleTableViewCellID";
static NSString *topCollectionViewCellId        =   @"topCollectionViewCellId";
static NSString *detailCollectionViewCellId     =   @"detailCollectionViewCellId";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIGestureRecognizerDelegate>{
    
    NSInteger           _beforeScrollViewTag;
    NSInteger           _currentScrollViewTag;
    NSInteger           _detailInfoCount;
    UITableView         *_titleTableView;
    UIScrollView        *_detailScrollView;
    UICollectionView    *_detailCollectionView;
    UICollectionView    *_topIconListView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailInfoCount = 5;
    [self loadTitleTableView];
    [self loadDetailView];
    [self loadTopIconListView];
}


#pragma mark - 左侧标题页面&顶部页面

- (void)loadTitleTableView {
    _titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopCarIconListViewHeight, kScreenWidth, kScreenHeight-kTopCarIconListViewHeight) style:UITableViewStylePlain];
    _titleTableView.tag         = TitleTableViewTag;
    _titleTableView.rowHeight   = rowHight;
    _titleTableView.delegate    = self;
    _titleTableView.dataSource  = self;
    _titleTableView.showsVerticalScrollIndicator = false;
    
    [self.view addSubview:_titleTableView];
}


#pragma mark - 右侧详情页面

- (void)loadDetailView {
    _detailScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(kAverageTableViewWidth, heightForHeaderInSection+kTopCarIconListViewHeight, kAverageTableViewWidth*2, kScreenHeight-kTopCarIconListViewHeight)];
    _detailScrollView.tag           =   DetailScrollViewTag;
    _detailScrollView.bounces       =   false;
    _detailScrollView.delegate      =   self;
    _detailScrollView.showsVerticalScrollIndicator      =  false;
    _detailScrollView.showsHorizontalScrollIndicator    =  false;
    _detailScrollView.contentSize   =   CGSizeMake(_detailInfoCount*kAverageTableViewWidth, numberOfRows*rowHight*numberOfSections+numberOfSections*heightForHeaderInSection);
    
    UICollectionViewFlowLayout *detailViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    detailViewFlowLayout.itemSize = CGSizeMake(kAverageTableViewWidth, numberOfRows*rowHight*numberOfSections+numberOfSections*heightForHeaderInSection);
    detailViewFlowLayout.minimumLineSpacing         =   0;
    detailViewFlowLayout.minimumInteritemSpacing    =   0;
    detailViewFlowLayout.scrollDirection            =   UICollectionViewScrollDirectionHorizontal;
    
    _detailCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, _detailInfoCount*kAverageTableViewWidth, numberOfRows*rowHight*numberOfSections+numberOfSections*heightForHeaderInSection) collectionViewLayout:detailViewFlowLayout];
    _detailCollectionView.userInteractionEnabled    =   false;
    _detailCollectionView.dataSource                =   self;
    _detailCollectionView.bounces                   =   false;
    _detailCollectionView.backgroundColor           =   [UIColor whiteColor];
    [_detailCollectionView registerClass:[DetailCollectionViewCell class] forCellWithReuseIdentifier:detailCollectionViewCellId];
    
    [self.view addSubview:_detailScrollView];
    [_detailScrollView addSubview:_detailCollectionView];
}


#pragma mark - 左侧标题页面

- (void)loadTopIconListView {
    UICollectionViewFlowLayout *topViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    topViewFlowLayout.itemSize = CGSizeMake(kAverageTableViewWidth, kTopCarIconListViewHeight);
    topViewFlowLayout.minimumLineSpacing        = 0;
    topViewFlowLayout.minimumInteritemSpacing   = 0;
    topViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _topIconListView = [[UICollectionView alloc] initWithFrame:CGRectMake(kAverageTableViewWidth, 20, kAverageTableViewWidth*2, kTopCarIconListViewHeight-20) collectionViewLayout:topViewFlowLayout];
    _topIconListView.tag                 = TopIconListViewTag;
    _topIconListView.bounces             = false;
    _topIconListView.delegate            = self;
    _topIconListView.dataSource          = self;
    _topIconListView.backgroundColor     = [UIColor whiteColor];
    _topIconListView.showsHorizontalScrollIndicator = false;
    
    [_topIconListView registerClass:[TopCollectionViewCell class] forCellWithReuseIdentifier:topCollectionViewCellId];
    
    [self.view addSubview:_topIconListView];
}


#pragma mark - CollectionView Datesoure

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _detailInfoCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _topIconListView) {
        TopCollectionViewCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:topCollectionViewCellId forIndexPath:indexPath];
        return topCell;
        
    }else {
        DetailCollectionViewCell *detailCell = [collectionView dequeueReusableCellWithReuseIdentifier:detailCollectionViewCellId forIndexPath:indexPath];
        return detailCell;
    }
}


#pragma mark - CollectionView Delegate

/**
 
 点击cell删除
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _detailInfoCount--;
    [_topIconListView deleteItemsAtIndexPaths:@[indexPath]];
    [_detailCollectionView deleteItemsAtIndexPaths:@[indexPath]];
    _detailScrollView.contentSize = CGSizeMake(_detailInfoCount*kAverageTableViewWidth, numberOfRows*rowHight*numberOfSections+numberOfSections*heightForHeaderInSection);
    [self showWithStatus:@"删除信息\n摇一摇即可恢复全部信息"];
    
    if (_detailInfoCount == 0) {
        [self showWithStatus:@"已删除全部信息\n摇一摇即可恢复全部信息"];
    }
}


#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfRows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:titleTableViewCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:titleTableViewCellID];
    }
    cell.textLabel.text = @(indexPath.section*numberOfSections + indexPath.row).description;
    return cell;
}


#pragma mark - Table View Dalegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return heightForHeaderInSection;
}

/**
 
 判断拖动的view的tag进行联动
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_currentScrollViewTag == TitleTableViewTag) {
        CGFloat offSetX = _beforeScrollViewTag == TopIconListViewTag ? _topIconListView.contentOffset.x : _detailScrollView.contentOffset.x;
        _detailScrollView.contentOffset = CGPointMake(offSetX, _titleTableView.contentOffset.y);
        _topIconListView.contentOffset = CGPointMake(offSetX, 0);
        return;
    }
    if (_currentScrollViewTag == DetailScrollViewTag) {
        _titleTableView.contentOffset = CGPointMake(0, _detailScrollView.contentOffset.y);
        _topIconListView.contentOffset = CGPointMake(_detailScrollView.contentOffset.x, 0);
        return;
    }
    if (_currentScrollViewTag == TopIconListViewTag) {
        CGFloat offSetY = _beforeScrollViewTag == TitleTableViewTag ? _titleTableView.contentOffset.y : _detailScrollView.contentOffset.y;
        _detailScrollView.contentOffset = CGPointMake(_topIconListView.contentOffset.x, offSetY);
        _titleTableView.contentOffset = CGPointMake(0, _detailScrollView.contentOffset.y);
        return;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 记录上一个拖动的view来保证再次滑动惯性效果不会停止
    _beforeScrollViewTag    =   _currentScrollViewTag;
    _currentScrollViewTag   =   scrollView.tag;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"第%zd组", section];
}


#pragma mark - GestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}


#pragma mark - 弹窗提示

- (void)showWithStatus:(NSString *)status {
    [SVProgressHUD showInfoWithStatus:status];
    [SVProgressHUD setBackgroundColor:[UIColor blackColor]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}


#pragma mark - 摇一摇恢复全部数据

/**
 
 检测到摇动
 */
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
//    NSLog(@"检测到摇动");
}

/**
 
 摇动取消(被中断)
 */
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    [SVProgressHUD showWithStatus:@"摇动取消(被中断)"];
}

/**
 
 摇动结束
 */
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"%@", _titleTableView);
    if (_detailInfoCount != 5) {
        _detailInfoCount = 5;
        [_topIconListView reloadData];
        [_detailCollectionView reloadData];
        _detailScrollView.contentSize = CGSizeMake(_detailInfoCount*kAverageTableViewWidth, numberOfRows*rowHight*numberOfSections+numberOfSections*heightForHeaderInSection);
        [self showWithStatus:@"已加载全部信息"];
    }else {
        [self showWithStatus:@"已经是全部信息"];
    }
    [self playSound];
}

/**
 
 播放摇一摇声音
 */
-(void)playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"5018" ofType:@"wav"];
    if (path) {
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&shake_sound_yao_id);
        AudioServicesPlaySystemSound(shake_sound_yao_id);
    }
    AudioServicesPlaySystemSound(shake_sound_yao_id);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
