//
//  DNHomeListRequestModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"



@interface DNHomeListRequestModel : DNWebServiceBaseModel

@property (nonatomic, copy) NSNumber *accountId; //非必须参数 用户id，查询这个用户多问答，我的问题页面必填
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *counts;  //每页多少条数据
@property (nonatomic, assign) DNHomeListType type;


@end
