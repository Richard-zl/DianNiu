//
//  DNDianniuQ_ACell.h
//  Dianniu
//
//  Created by RIMI on 2016/11/30.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNDianniuQ_AViewModel.h"
#import "DNQuestingPraiseRequestModel.h"


@interface DNDianniuQ_ACell : UITableViewCell
@property (nonatomic, strong)DNDianniuQ_AViewModel *dianniuQ_AViewModel;
@property (nonatomic, copy) void(^didClickDetailView)(DNDianniuQ_AViewModel *viewModel);

@end
