//
//  DNAnswerViewModel.h
//  Dianniu
//
//  Created by RIMI on 2016/12/16.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DNAnswerViewModel : NSObject
@property (nonatomic, copy) NSString *accountId;
@property (nonatomic, copy) NSString *aliasName;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *headPic;
@property (nonatomic, copy) NSString *label;
@property (nonatomic, copy) NSString *realName;
@property (nonatomic, copy) NSString *aliasHeadPic;
@property (nonatomic, assign) NSInteger goodCount;
@property (nonatomic, assign) NSInteger allGoodCount;//加上我的点赞
@property (nonatomic, assign) BOOL isGood;
@property (nonatomic, copy) NSString *questId;

@property (nonatomic, copy) NSString *answerId;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWhitDictionary:(NSDictionary *)dict;
@end
