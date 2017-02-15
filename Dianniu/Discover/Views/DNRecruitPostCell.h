//
//  DNRecruitPostCell.h
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNRecruitDetailRequest.h"
@interface DNRecruitPostCell : UITableViewCell
@property (nonatomic, strong) NSMutableDictionary *dataSource;
@property (nonatomic, assign) DNRecruitDetailType type;
@end
