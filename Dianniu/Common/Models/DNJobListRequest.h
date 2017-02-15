//
//  DNJobListRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

@interface DNJobListRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, copy) NSString *post;      //岗位名称
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger type;    //0全部 1我的
@end
