//
//  DNReportViewC.h
//  Dianniu
//
//  Created by RIMI on 2016/12/26.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DNReportRequest.h"
//举报页
@interface DNReportViewC : UIViewController
- (instancetype)initWithReportType:(DNReportType)type tergetId:(NSNumber *)kid;
@end
