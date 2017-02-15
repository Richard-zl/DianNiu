//
//  DNRecruitAddRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/25.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNRecruitDetailRequest.h"
@interface DNRecruitAddRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, strong) NSNumber *requestId;
@property (nonatomic, assign) DNRecruitDetailType type;
@property (nonatomic, copy) NSString *content;
@end
