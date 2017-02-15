//
//  DNRecruitDetailRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNRecruitDetailViewC.h"

@interface DNRecruitDetailRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, strong) NSNumber *requestId;
@property (nonatomic, assign) DNRecruitDetailType type;
@end
