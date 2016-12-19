//
//  DNUserDetailModel.h
//  Dianniu
//
//  Created by RIMI on 2016/12/19.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNUserDetailModel : NSObject
@property (nonatomic, copy) NSNumber *userId; //用户id
@property (nonatomic, copy) NSNumber *dnNum; //电钮号
@property (nonatomic, copy) NSString *realName; //昵称
@property (nonatomic, copy) NSString *aliasName;//花名
@property (nonatomic, copy) NSString *headPic;  //头像名称
@property (nonatomic, copy) NSString *mobile;  //手机号
@property (nonatomic, copy) NSString *describe; //个性签名
@property (nonatomic, copy) NSString *label;    ///标签
@property (nonatomic, assign) NSInteger authLevel; //认证等级
@property (nonatomic, assign) NSInteger sex;     ///性别 0女 1男
@property (nonatomic, assign) NSInteger dataPrivacy; ///隐私可见，0所有人可见 1好友可见
@property (nonatomic, assign) BOOL unableBeFriend;  ///是否可以加好友 0所有人可以  1不允许加好友
@property (nonatomic, assign) BOOL isFriend;  ///是否是好友 0否 1是   //该参数会引起崩溃(因为服务器返回了null，强行解析成bool类型会失败) (已修复 重写setValue方法  如果key和value有一个为空或null就不调用super)
@property (nonatomic, assign) BOOL isFollow;  ///是否已经关注


- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWhitDictionary:(NSDictionary *)dict;
@end
