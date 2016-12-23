//
//  DNAddQuestionView.h
//  Dianniu
//
//  Created by RIMI on 2016/12/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNAddQuestionView : UIView

- initWithClickIndex:(void(^)(DNHomeListType type))callback;

- (void)show;
@end
