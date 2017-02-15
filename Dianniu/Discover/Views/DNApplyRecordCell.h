//
//  DNApplyRecordCell.h
//  Dianniu
//
//  Created by RIMI on 2017/2/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNRecruitAddRequest.h"
#import "NSDictionary+FixNilBug.h"

@interface DNApplyRecordCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *dataSource;
@property (nonatomic, assign) DNRecruitDetailType type;
@end
