//
//  DNActivityListRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/2/11.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNActivityTableViewC.h"

@interface DNActivityListRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, assign) DNActivityType activityType;
@property (nonatomic, copy) NSString *loaction;
@property (nonatomic, assign) NSInteger page;

@end
