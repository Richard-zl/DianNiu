//
//  DNAddQuestionView.h
//  Dianniu
//
//  Created by RIMI on 2016/12/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    DNAddquestionViewDisplayType_Qustion,
    DNAddquestionViewDisplayType_Recruit,
} DNAddquestionViewDisplayType;

@interface DNAddQuestionView : UIView

- initWithDisplayType:(DNAddquestionViewDisplayType)type ClickIndex:(void(^)(DNHomeListType type))callback;

- (void)show;
@end
