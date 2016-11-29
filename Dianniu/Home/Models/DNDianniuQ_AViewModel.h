//
//  DNDianniuQ_AViewModel.h
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DNDianniuQ_AModel.h"

@interface DNDianniuQ_AViewModel : NSObject
@property (nonatomic, strong) DNDianniuQ_AModel* q_aModel;

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *tagText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, assign) NSInteger answerCount;
@property (nonatomic, assign) BOOL isFriend;

- (instancetype)initWithQ_AModel:(DNDianniuQ_AModel *)model;
@end
