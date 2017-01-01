//
//  DNReportRequest.h
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNWebServiceBaseModel.h"

typedef NS_ENUM(NSUInteger, DNReportType) {
    DNReportType_User = 1,   //举报用户
    DNReportType_Quest,  //举报问题
    DNReportType_Resume, //举报建立
    DNReportType_Recruit //举报招聘信息
};
//举报
@interface DNReportRequest : DNWebServiceBaseModel
@property (nonatomic, assign) DNReportType type;
@property (nonatomic, strong) NSNumber *targetId;
@property (nonatomic, copy) NSString *reasonModel;
@property (nonatomic, strong)NSNumber *accountId;
@end
