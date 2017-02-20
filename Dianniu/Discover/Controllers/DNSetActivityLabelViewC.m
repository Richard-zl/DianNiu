//
//  DNSetActivityLabelViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/17.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNSetActivityLabelViewC.h"
#import "DNLabelSetCell.h"

#define DNLabelSetViewCellEdge 10.0
#define DNLabelSetViewCellIdentifier @"DNLabelSetViewCellIdentifier"

@interface DNSetActivityLabelViewC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSString *selectedLabel;
@end

@implementation DNSetActivityLabelViewC

- (void)viewDidLoad {
    [self configurCollectionView];
}

- (void)configurCollectionView{
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:@"DNLabelSetCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:DNLabelSetViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNLabelSetViewCellHederViewId"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake((ScreenWidth - DNLabelSetViewCellEdge * 4)/3, 40);
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = DNLabelSetViewCellEdge;
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 45);
}

- (void)dealSelectString:(BOOL)insert label:(NSString *)label{
    if (insert) {
        if (!self.selectedLabel) {
            self.selectedLabel = label;
        }else{
            self.selectedLabel = [self.selectedLabel stringByAppendingString:[NSString stringWithFormat:@",%@",label]];
        }
    }else{
        NSMutableArray *strArr = [[self.selectedLabel componentsSeparatedByString:@","] mutableCopy];
        if ([strArr containsObject:label]) {
            [strArr removeObject:label];
        }
        self.selectedLabel = @"";
        for (NSString *str in strArr) {
            self.selectedLabel = [self.selectedLabel stringByAppendingString:[NSString stringWithFormat:@"%@,",str]];
        }
        self.selectedLabel = [self.selectedLabel substringToIndex:self.selectedLabel.length -1 ];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.dataSource count];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,DNLabelSetViewCellEdge, 0, DNLabelSetViewCellEdge);//分别为上、左、下、右
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DNLabelSetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DNLabelSetViewCellIdentifier forIndexPath:indexPath];
    [cell.titleBut setTitle:self.dataSource[indexPath.row] forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    DNWeakself
    cell.didSelected = ^(BOOL selected,NSIndexPath *path,UIButton *target){
        if (weakSelf.didSelectedLabel) {
            [weakSelf dealSelectString:target.isSelected label:[target titleForState:UIControlStateNormal]];
            weakSelf.didSelectedLabel(weakSelf.selectedLabel);
        }
    };
    return cell;
}

#pragma mark - getter
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"运营",@"设计",@"客服",@"店长",@"售后",@"仓管",@"其他"];
    }
    return _dataSource;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGBColor(241, 241, 241);
    }
    return _collectionView;
}

@end
