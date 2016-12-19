//
//  DNQuestingPraiseRequestModel.h
//  Dianniu
//
//  Created by RIMI on 2016/12/13.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
//问题点赞
@interface DNQuestingPraiseRequestModel : DNWebServiceBaseModel
@property (nonatomic, copy) NSNumber *accountId;
@property (nonatomic, copy) NSNumber *questingId;
@end
