//
//  DNMoreLabelViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNMoreLabelViewC.h"
#import "DNLabelSetCell.h"

#define DNLabelSetViewCellEdge 10.0
#define DNLabelSetViewCellIdentifier @"DNLabelSetViewCellIdentifier"

@interface DNMoreLabelViewC ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSArray *dataSource;

@end

@implementation DNMoreLabelViewC

- (void)viewDidLoad {
    [self configurCollectionView];
}

- (void)configurCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:@"DNLabelSetCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:DNLabelSetViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNLabelSetViewCellHederViewId"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake((ScreenWidth - DNLabelSetViewCellEdge * 4)/3, 40);
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = DNLabelSetViewCellEdge;
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 45);
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
        if ([weakSelf.delegate respondsToSelector:@selector(didSelectedLabel:)]) {
            [weakSelf.delegate didSelectedLabel:target];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    return cell;
}

#pragma mark - getter
- (NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = @[@"箱包",@"童装玩具",@"内衣",@"母婴用品",@"家电",@"美妆",@"洗护",@"保健品",@"珠宝",@"眼镜",@"手表",@"户外",@"乐器",@"游戏",@"动漫",@"影视",@"美食",@"生鲜",@"零食",@"鲜花",@"宠物",@"农药",@"房产",@"装修",@"建材",@"家具",@"家饰",@"家纺",@"汽车用品",@"办公用品",@"五金电子",@"百货",
                        @"图书",@"卡券",@"本地服务"];
    }
    return _dataSource;
}

@end
