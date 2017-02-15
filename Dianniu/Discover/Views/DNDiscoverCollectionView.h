//
//  DNDiscoverCollectionView.h
//  Dianniu
//
//  Created by RIMI on 2017/1/23.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNDiscoverCollectionView : UICollectionView<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, copy)void(^didClickTypeButton)(NSString *typeString);
@end
