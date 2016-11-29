//
//  DNDianniuQ_ATableViewC.h
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNHomeListRequestModel.h"
#import "DNDianniuQ_AViewModel.h"

//电钮问答tableViewController
@interface DNDianniuQ_ATableViewC : UITableViewController
@property (nonatomic, assign) DNHomeListType type;

- (void)tableViewDidReload:(NSMutableDictionary *)dataDict;

@end
