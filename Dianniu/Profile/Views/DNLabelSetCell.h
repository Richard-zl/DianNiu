//
//  DNLabelSetCell.h
//  Dianniu
//
//  Created by RIMI on 2017/1/6.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNLabelSetCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleBut;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^didSelected)(BOOL selected,NSIndexPath *indexPath,UIButton *target);
@end
