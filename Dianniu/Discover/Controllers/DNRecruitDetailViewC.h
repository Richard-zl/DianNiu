//
//  DNRecruitDetailViewC.h
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DNRecruitDetailType_JOB = 1,//用于发布招聘、和招聘申请列表
    DNRecruitDetailType_RECRUIT//用于发布求职、和求职申请列表
} DNRecruitDetailType;
@interface DNRecruitDetailViewC : UIViewController
@property (nonatomic, assign)DNRecruitDetailType type;
@property (nonatomic, assign)NSNumber *requestId;
@end
