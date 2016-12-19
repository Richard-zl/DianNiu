//
//  DNUserDetailRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/19.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

//查看用户详情
@interface DNUserDetailRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSNumber *accountId;
@property (nonatomic, copy) NSNumber *friendAccountId;
@end
