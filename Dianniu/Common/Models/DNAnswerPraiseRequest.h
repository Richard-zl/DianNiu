//
//  DNAnswerPraiseRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

///回答点赞
@interface DNAnswerPraiseRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSNumber *accountId;
@property (nonatomic, copy) NSNumber *questId;
@property (nonatomic, copy) NSNumber *answerId;
@end
