//
//  DNSelectControl.h
//  Dianniu
//
//  Created by RIMI on 2017/1/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNSelectControl : UITextField
@property (nonatomic, copy) void(^selectedBlock)(NSString *value,NSString *id_value);

- (void)show;
- (void)dismiss;
@end
