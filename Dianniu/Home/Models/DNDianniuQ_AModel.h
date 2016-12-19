//
//  DNDianniuQ_AModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

//电钮问答 数据model
@interface DNDianniuQ_AModel : NSObject
@property (nonatomic, copy) NSNumber *q_aId;//问题id
@property (nonatomic, assign) BOOL top;       //是否置顶
@property (nonatomic, copy) NSString *realName;//真实姓名
@property (nonatomic, copy) NSString *aliasName;//昵称
@property (nonatomic, copy) NSString *content;  //问答内容
@property (nonatomic, copy) NSString *questImgs;//配图名称 用,分割
@property (nonatomic, copy) NSNumber *accountId;//账户id
@property (nonatomic, assign) NSInteger goodCount; //点赞次数
@property (nonatomic, assign) NSInteger answerCount; //回答次数
@property (nonatomic, assign) NSInteger visitorCount; //浏览次数
@property (nonatomic, assign) NSInteger forwardCount; //转发次数
@property (nonatomic, assign) BOOL isGood; //是否点赞
@property (nonatomic, assign) BOOL isFriend;// 是否为好友
@property (nonatomic, copy) NSString *headPic; //头像图片名称
@property (nonatomic, copy) NSString *label;//标签
@property (nonatomic, copy) NSString *createDate;//创建时间
@property (nonatomic, copy) NSString *updateDate; //更新时间
@property (nonatomic, copy) NSString *answerContent;//最后一条回答内容

+ (instancetype)modelWithQ_ADictionary:(NSDictionary *)dataDic;

@end
