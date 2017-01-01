//
//  DNCollectRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

//增加、删除问题收藏
@interface DNCollectRequest : DNWebServiceBaseModel
@property (nonatomic, strong) NSNumber *accountId;
@property (nonatomic, strong) NSNumber *questId;
@end
