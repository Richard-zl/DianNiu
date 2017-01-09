//
//  DNProfileModifyRequest.h
//  Dianniu
//
//  Created by RIMI on 2017/1/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

typedef enum : NSUInteger {
    DNProfileModifyType_Header,      //头像
    DNProfileModifyType_DataPrivacy, //数据隐私 （谁可以看我的资料）
    DNProfileModifyType_BeFirend,    //谁可以加我好友
    DNProfileModifyType_Sex,         //性别 0女 1男
    DNProfileModifyType_Describe,    //个性签名
    DNProfileModifyType_Label,       //标签   XX／XX／XX／
    DNProfileModifyType_Realname     //昵称
} DNProfileModifyType;

@interface DNProfileModifyRequest : DNWebServiceBaseModel
@property (nonatomic, assign) DNProfileModifyType type;
@property (nonatomic, strong) NSObject *value;
@property (nonatomic, strong) NSNumber *accountId;
@end
