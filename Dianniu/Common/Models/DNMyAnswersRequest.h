//
//  DNMyAnswersRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

@interface DNMyAnswersRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, assign) NSInteger page;

@end
