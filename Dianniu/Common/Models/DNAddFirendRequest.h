//
//  DNAddFirendRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/21.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

//添加朋友
@interface DNAddFirendRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSNumber *accountId;
@property (nonatomic, copy) NSNumber *friendAccountId;
@end
