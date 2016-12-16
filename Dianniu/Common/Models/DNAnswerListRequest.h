//
//  DNAnswerListRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

//问题回答列表
@interface DNAnswerListRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *questId;
@property (nonatomic, assign) NSInteger page;
@end
