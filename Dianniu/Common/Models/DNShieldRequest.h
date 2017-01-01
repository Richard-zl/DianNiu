//
//  DNShieldRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
//屏蔽、删除屏蔽请求
@interface DNShieldRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, strong) NSNumber *shieldAccountId;
@end
