//
//  DNPicturebrowsingC.m
//  Dianniu
//
//  Created by RIMI on 2016/12/7.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNPicturebrowsingC.h"
#import <UIImageView+WebCache.h>
@interface DNPicturebrowsingC()
@property (nonatomic, strong)UIPageControl *pageControl;
@end
@implementation DNPicturebrowsingLayout

- (void)prepareLayout{
    [super prepareLayout];
    self.itemSize = CGSizeMake(ScreenWidth, ScreenHeight);
    self.minimumLineSpacing = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end

#define DNPicturebrowsingCell @"DNPicturebrowsingCell"
#define DNPicturebrowsingImageTag 0x000FF

@interface DNPicturebrowsingC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSIndexPath *currentIndex;
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation DNPicturebrowsingC

- (instancetype)initWithDatasource:(NSArray <NSString *> *)dataSource andIndex:(NSIndexPath *)indexpath{
    if ([super init]) {
        self.dataSource = dataSource;
        self.currentIndex = indexpath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
#pragma mark - configurUI
- (void)configurSubViews{
    [self.view addSubview:self.collectionView];
    if (self.dataSource.count > 1) {
        [self.view addSubview:self.pageControl];
        [self.collectionView scrollToItemAtIndexPath:self.currentIndex atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - private func
- (void)didClickImage{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UICollectionView func
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DNPicturebrowsingCell forIndexPath:indexPath];
    UIImageView *imageView = [cell.contentView viewWithTag:DNPicturebrowsingImageTag];
    if (!imageView) {
        imageView = [[UIImageView alloc] initWithFrame:collectionView.bounds];
        imageView.width = imageView.width - 10;
        imageView.left  = 5;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickImage)];
        [imageView addGestureRecognizer:tap];
        imageView.userInteractionEnabled = YES;
        imageView.tag = DNPicturebrowsingImageTag;
        [cell.contentView addSubview:imageView];
    }
    [imageView sd_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:self.dataSource[indexPath.item]] placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [SVProgressHUD showProgress:expectedSize / receivedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [SVProgressHUD dismiss];
    }];
 
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    self.pageControl.currentPage = [self.collectionView indexPathsForVisibleItems][0].row;
}

#pragma mark - getter
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:[[DNPicturebrowsingLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:DNPicturebrowsingCell];
    }
    return _collectionView;
}

- (UIPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, ScreenHeight - 60, ScreenWidth, 40)];
        _pageControl.numberOfPages = self.dataSource.count;
        _pageControl.currentPage   = self.currentIndex.row;
    }
    return _pageControl;
}

@end



