//
//  DNDateSelectControl.h
//  Dianniu
//
//  Created by RIMI on 2017/2/15.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNDateSelectControl : UITextField
@property (nonatomic, copy) void(^didSelected)(NSString *dateStr);

- (void)show;
- (void)dismiss;
@end
