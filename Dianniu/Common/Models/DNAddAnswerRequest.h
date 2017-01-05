//
//  DNAddAnswerRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/3.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

@interface DNAddAnswerRequest : DNWebServiceBaseModel
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) NSNumber *questId;
@property (nonatomic, strong)NSNumber *accountId;
@end
