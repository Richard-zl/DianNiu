//
//  DNQuestionsSearchRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/20.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNHomeListRequestModel.h"
//问答搜索
@interface DNQuestionsSearchRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) DNHomeListType type;
@end
