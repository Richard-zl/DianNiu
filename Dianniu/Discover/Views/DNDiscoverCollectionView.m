//
//  DNDiscoverCollectionView.m
//  Dianniu
//
//  Created by RIMI on 2017/1/23.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNDiscoverCollectionView.h"
#import "DNLabelSetCell.h"


#define DNLabelSetViewCellIdentifier @"DNLabelSetViewCellIdentifier"

@interface DNDiscoverCollectionView ()
@property (nonatomic, copy) NSArray *dataArr;
@property (nonatomic, strong) UIButton *lastBut;
@end

@implementation DNDiscoverCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor = RGBColor(241, 241, 241);
        UICollectionViewFlowLayout *flayout = (UICollectionViewFlowLayout *)layout;
        flayout.itemSize = CGSizeMake((ScreenWidth - 8 * 5)/4, 35);
        flayout.minimumLineSpacing = 5;
        flayout.minimumInteritemSpacing = 8;
        [self registerNib:[UINib nibWithNibName:@"DNLabelSetCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:DNLabelSetViewCellIdentifier];
        self.delegate = self;
        self.dataSource = self;
        self.scrollEnabled = NO;
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataArr.count;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake( 8, 8, 8, 8);//分别为上、左、下、右
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DNLabelSetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DNLabelSetViewCellIdentifier forIndexPath:indexPath];
    [cell.titleBut setTitle:self.dataArr[indexPath.row] forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    if (!self.lastBut && indexPath.row == 0) {
        cell.titleBut.selected = YES;
        self.lastBut = cell.titleBut;
    }
    if (cell.contentView.layer.cornerRadius != 3.0){
        cell.contentView.layer.cornerRadius = 3.0;
        cell.contentView.layer.masksToBounds = YES;
    }
    DNWeakself
    cell.didSelected = ^(BOOL selected,NSIndexPath *path,UIButton *target){
        if (selected) {
            weakSelf.lastBut.selected = NO;
            weakSelf.lastBut = target;
            if (weakSelf.didClickTypeButton) {
                weakSelf.didClickTypeButton(target.currentTitle);
            }
        }else{
            target.selected = YES;
        }
    };
    
    return cell;
}

#pragma mark - getter
- (NSArray *)dataArr{
    if (!_dataArr) {
        _dataArr = @[@"全部",@"运营",@"设计",@"客服",@"店长",@"售后",@"仓管",@"其他"];
    }
    return _dataArr;
}

@end
