//
//  DNDianniuAnswerCell.h
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNAnswerViewModel.h"
#import "DNHomeListRequestModel.h"
#import <UIImageView+WebCache.h>
#import "DNAnswerPraiseRequest.h"

@interface DNAnswerCell : UITableViewCell
@property (nonatomic, strong) DNAnswerViewModel* viewModel;
@property (nonatomic, assign) DNHomeListType type;
@end
