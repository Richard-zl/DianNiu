//
//  DNAddJobRecruitRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNRecruitDetailRequest.h"

@interface DNAddJobRecruitRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSString *post;
@property (nonatomic, copy) NSString *salary;
@property (nonatomic, strong) NSNumber *tryout;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *experience;
@property (nonatomic, strong) NSNumber *recruitNumber;
@property (nonatomic, copy) NSString *education;
@property (nonatomic, copy) NSString *describe;
@property (nonatomic, copy) NSString *contact;
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, assign) DNRecruitDetailType type;
@end
