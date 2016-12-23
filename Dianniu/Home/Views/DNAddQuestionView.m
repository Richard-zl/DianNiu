//
//  DNAddQuestionView.m
//  Dianniu
//
//  Created by RIMI on 2016/12/22.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAddQuestionView.h"

#define DNAddQuestionViewContentHeight 204

@interface DNAddQuestionView()
@property (nonatomic, copy) void(^didClicked)(DNHomeListType type);
@property (nonatomic, strong) UIView *contentView;
@end

@implementation DNAddQuestionView

- (id)initWithClickIndex:(void (^)(DNHomeListType))callback{
    self = [super init];
    if (self) {
        self.didClicked = [callback copy];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        [self addSubview:self.contentView];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)buttonAction:(UIButton *)sender{
    if (self.didClicked) {
        self.didClicked(sender.tag);
    }
    [self dismiss];
}

- (void)dismiss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.01;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)show{
    [UIView animateWithDuration:0.8 delay:0.3 usingSpringWithDamping:0.5 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.contentView.top = (ScreenHeight - DNAddQuestionViewContentHeight) *0.5;
        for (UIView *subView in self.contentView.subviews) {
            if (subView.alpha == 0) {
                subView.alpha = 1;
            }
        }
    } completion:^(BOOL finished) {
    }];
}


#pragma mark - private
- (UIView *)createViewWithType:(DNHomeListType )type{
    CGRect frame = CGRectMake(0, 0, self.contentView.width/2.0, self.contentView.height);
    NSString *title,*imageName;
    CGFloat imageWH = 73.0;
    CGFloat labelheight = 20.0;
    if (type == DNHomeListType_questions) {
        frame.origin.x = 0;
        title = @"提出问题";
        imageName = @"tiwen_button";
    }else{
        frame.origin.x = self.contentView.center.x;
        title = @"匿名逼格";
        imageName = @"niming_button";
    }
    
    CGFloat buttonX = (self.contentView.width/2.0 - imageWH)/2.0;
    CGFloat buttonY = (self.contentView.height/2.0 - imageWH + 40)/2.0;
    UIView *view  = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor clearColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.frame = CGRectMake(buttonX, buttonY, imageWH, imageWH);
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = type;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, buttonY + button.height + 20, view.width, labelheight)];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    [view addSubview:button];
    [view addSubview:label];
    view.alpha = 0;
    return view;
}

#pragma mark - getter 
- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(15, -DNAddQuestionViewContentHeight, ScreenWidth - 30, DNAddQuestionViewContentHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 4.0;
        [_contentView addSubview:[self createViewWithType:DNHomeListType_questions]];
        [_contentView addSubview:[self createViewWithType:DNHomeListType_anonymity]];
    }
    return _contentView;
}

@end
