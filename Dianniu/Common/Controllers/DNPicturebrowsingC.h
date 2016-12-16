//
//  DNPicturebrowsingC.h
//  Dianniu
//
//  Created by RIMI on 2016/12/7.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNPicturebrowsingLayout : UICollectionViewFlowLayout

@end

@interface DNPicturebrowsingC : UIViewController

//不适用init
- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithDatasource:(NSArray <NSString *> *)dataSource andIndex:(NSIndexPath *)indexpath;

@end
