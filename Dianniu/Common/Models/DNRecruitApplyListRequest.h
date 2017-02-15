//
//  DNRecruitApplyListRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/2/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNRecruitAddRequest.h"

@interface DNRecruitApplyListRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, assign) DNRecruitDetailType type;
@property (nonatomic, assign) NSInteger page;
@end
