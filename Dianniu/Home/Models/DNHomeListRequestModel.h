//
//  DNHomeListRequestModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"



@interface DNHomeListRequestModel : DNWebServiceBaseModel

typedef enum : NSUInteger {
    DNHomeListType_questions = 1,//电钮问答
    DNHomeListType_anonymity,//匿名问答
    DNHomeListType_My,       //我的问答
} DNHomeListType;

@property (nonatomic, copy) NSString *accountId; //非必须参数 用户id，查询这个用户多问答，我的问题页面必填
@property (nonatomic, strong) NSNumber *page;
@property (nonatomic, strong) NSNumber *counts;  //每页多少条数据
@property (nonatomic, assign) DNHomeListType type;


@end
