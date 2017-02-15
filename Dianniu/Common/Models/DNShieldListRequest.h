//
//  DNShieldListRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
typedef NS_ENUM(NSUInteger, DNRequestListType) {
    DNRequestListType_Shield,
    DNRequestListType_Blacklist
};

//屏蔽、黑名单列表
@interface DNShieldListRequest : DNWebServiceBaseModel
@property (nonatomic, assign)DNRequestListType listType;
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, assign) NSInteger page;
@end
