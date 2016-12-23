//
//  DNShareCountRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

//分享/转发数增加
@interface DNShareCountRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, strong) NSNumber *questId;
@property (nonatomic, assign) NSInteger platform;//分享到哪个平台
@end
