//
//  DNSingleSelectControl.h
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNReleaseRecruitViewC.h"
@interface DNSingleSelectControl : UITextField
@property (nonatomic, copy) void(^selectedBlock)(NSString *value,DNReleaseRecruitParam param);

- (void)showData:(NSArray <NSString *>*)data andParam:(DNReleaseRecruitParam)param;
- (void)dismiss;
@end
