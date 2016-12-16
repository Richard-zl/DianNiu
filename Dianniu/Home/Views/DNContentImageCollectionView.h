//
//  DNContentImageCollectionView.h
//  Dianniu
//
//  Created by RIMI on 2016/12/7.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNContentImageCollectionView : UICollectionView <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)NSArray <NSString *> *imageStrs;

@end
