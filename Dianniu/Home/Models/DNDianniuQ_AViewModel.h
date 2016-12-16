//
//  DNDianniuQ_AViewModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDianniuQ_AModel.h"
#import <ALBBMediaService/ALBBMediaService.h>

@interface DNDianniuQ_AViewModel : NSObject
@property (nonatomic, strong) DNDianniuQ_AModel* q_aModel;


@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *tagText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, assign) NSInteger allPraiseCount;
@property (nonatomic, assign) NSInteger answerCount;
@property (nonatomic, strong) NSArray<NSString *> *contentImageStrs;
@property (nonatomic, strong) NSString  *hedaerImageStr;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) BOOL isPraise;

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithQ_AModel:(DNDianniuQ_AModel *)model;
@end
