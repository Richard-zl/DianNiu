//
//  DNContentImageCollectionView.m
//  Dianniu
//
//  Created by RIMI on 2016/12/7.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNContentImageCollectionView.h"
#import <UIImageView+WebCache.h>

@implementation DNContentImageCollectionView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.dataSource = self;
    self.delegate   = self;
    [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DNImageCell"];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   return  self.imageStrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DNImageCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:10];
    if (!imageView) {
        CGFloat imageWH = (ScreenWidth - 60 - 10)/3;
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imageWH, imageWH)];
        imageView.tag = 10;
        imageView.contentMode = UIViewContentModeScaleToFill;
        [cell.contentView addSubview:imageView];
    }
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.imageStrs[indexPath.item]] placeholderImage:[UIImage imageWithColor:[UIColor lightGrayColor] size:imageView.size]];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info = @{@"DNImageURLStrings":self.imageStrs,@"indexPath":indexPath};
    DNEvent(kDNKeyNoticeShowImage, info);
}

- (void)setImageStrs:(NSArray<NSString *> *)imageStrs{
    _imageStrs = imageStrs;
    [self reloadData];
}

@end
