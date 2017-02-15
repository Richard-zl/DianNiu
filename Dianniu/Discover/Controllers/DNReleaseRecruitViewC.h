//
//  DNReleaseRecruitViewC.h
//  Dianniu
//
//  Created by RIMI on 2017/2/7.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNRecruitDetailViewC.h"

typedef enum : NSUInteger {
    DNReleaseRecruitParam_Post,
    DNReleaseRecruitParam_Salary,
    DNReleaseRecruitParam_Tryout,
    DNReleaseRecruitParam_Area,
    DNReleaseRecruitParam_Experience,
    DNReleaseRecruitParam_Education
} DNReleaseRecruitParam;

@interface DNReleaseRecruitViewC : UIViewController
@property (nonatomic, assign)DNRecruitDetailType releaseType;
@end
