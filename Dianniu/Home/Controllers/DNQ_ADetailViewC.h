//
//  DNQ_ADetailViewC.h
//  Dianniu
//
//  Created by RIMI on 2016/12/14.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNHomeListRequestModel.h"
#import "DNDianniuQ_AViewModel.h"
#import "DNAnswerListRequest.h"
#import <MJRefresh.h>

@interface DNQ_ADetailViewC : UIViewController
@property (nonatomic, assign) DNHomeListType type;
@property (nonatomic, assign) DNDianniuQ_AViewModel *q_aModel;
@end
