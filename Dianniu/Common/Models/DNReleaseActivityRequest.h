//
//  DNReleaseActivityRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/2/17.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import <CoreLocation/CoreLocation.h>
@interface DNReleaseActivityRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSString *title; ///活动标题
@property (nonatomic, copy) NSString *startDate; ///开始时间
@property (nonatomic, copy) NSString *address;   ///地址
@property (nonatomic, copy) NSString *number;    ///人数区间
@property (nonatomic, strong) NSNumber *payType;   ///付款模式 1AA 2免费
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, assign) CLLocationCoordinate2D coord;
@end
