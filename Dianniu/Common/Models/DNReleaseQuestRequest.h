//
//  DNReleaseQuestRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/27.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"
#import "DNHomeListRequestModel.h"
//问题发布
@interface DNReleaseQuestRequest : DNWebServiceBaseModel
@property (nonatomic, assign) DNHomeListType type;
@property (nonatomic, strong) NSNumber *accountId; //非必填
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *questImgs; //多张图片用逗号分隔
@end
