//
//  DNQ_ADetailHederView.h
//  Dianniu
//
//  Created by RIMI on 2016/12/14.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNHomeListRequestModel.h"
#import "DNDianniuQ_AViewModel.h"

@interface DNQ_ADetailHederView : UIView

@property (nonatomic,assign)DNHomeListType type;
@property (nonatomic,strong)DNDianniuQ_AViewModel *model;
@property (nonatomic, copy) void(^didCalculatedHeight)(CGFloat height);
@end
