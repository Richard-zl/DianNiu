//
//  DNRecruitBaseViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/23.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitBaseViewC.h"
#import "DNJobViewC.h"
#import "DNRecruitViewC.h"
#import "DNRecruitRecordViewC.h"
#import "DNAddQuestionView.h"
#import "DNInformationViewC.h"
#import "DNReleaseRecruitViewC.h"

#define DNRecruitCategoryButtonTag 500
@interface DNRecruitBaseViewC ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (nonatomic, strong) NSMutableArray *controllers;
@end

@implementation DNRecruitBaseViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"求职招聘";
    [self configurSubViews];
}

#pragma mark - UI Metheod
- (void)configurSubViews{
    [self configurScrollView];
    [self configurRightButton];
    DNJobViewC *jobViewC = [[DNJobViewC alloc] init];
    DNRecruitViewC *recruitView = [[DNRecruitViewC alloc] init];
    DNRecruitRecordViewC *recordViewC = [[DNRecruitRecordViewC alloc] init];
    //因为必须强持有两个控制器  才不会刚创建就被销毁
    self.controllers = [NSMutableArray arrayWithArray:@[jobViewC,recruitView,recordViewC]];
    [self.scrollView addSubview:jobViewC.view];
    recruitView.view.left = jobViewC.view.right;
    [self.scrollView addSubview:recruitView.view];
    recordViewC.view.left = recruitView.view.right;
    [self.scrollView addSubview:recordViewC.view];
}

- (void)configurRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"我要发布" style:UIBarButtonItemStylePlain target:self action:@selector(postButtonAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configurScrollView{
    self.scrollView.contentSize = CGSizeMake(ScreenWidth*3, ScreenHeight - self.topView.bottom);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.bounces = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    
}

#pragma mark - private func
- (void)deselectCategoryButtn{
    for (UIView *subView in self.topView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *categoryBut = (UIButton *)subView;
            if (categoryBut.isSelected) {
                categoryBut.selected = NO;
                categoryBut.userInteractionEnabled = YES;
                return;
            }
        }
    }
}

#pragma mark - Event
///发布按钮点击事件
- (void)postButtonAction{
    if ([DNUser sheared].authLevel < DNUSerAuthLevel_TWO) {
        //没有权限发招聘
        DNTextAlert(nil, @"您还未完成二级认证，请先验证！", @[@"确认",@"取消"], ^(NSInteger index) {
            if (index == 0) {
#warning 跳转到权限认证页面
                DNInformationViewC *viewC = [[DNInformationViewC alloc] initWithNibName:@"DNInformationViewC" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:viewC animated:YES];
            }
        });
        return ;
    }
    DNAddQuestionView *view = [[DNAddQuestionView alloc] initWithDisplayType:DNAddquestionViewDisplayType_Recruit ClickIndex:^(DNHomeListType type) {
        DNReleaseRecruitViewC *releaseRecruitViewC = [[DNReleaseRecruitViewC alloc] init];
        releaseRecruitViewC.releaseType = type == 1 ? DNRecruitDetailType_JOB : DNRecruitDetailType_RECRUIT;
        [self.navigationController pushViewController:releaseRecruitViewC animated:YES];
    }];
    [DNSharedDelegate.window addSubview:view];
    [view show];
}

- (IBAction)categoryButtonAction:(UIButton *)sender {
    if (!sender.isSelected) {
        [self deselectCategoryButtn];
        [self.scrollView setContentOffset:CGPointMake((sender.tag - DNRecruitCategoryButtonTag)*self.scrollView.width , 0) animated:YES] ;
        sender.selected = YES;
        sender.userInteractionEnabled = NO;
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger offSetX = self.scrollView.contentOffset.x;
    NSInteger width   = ScreenWidth;
    NSInteger tag = offSetX/width + DNRecruitCategoryButtonTag;
    UIButton *selectBut = (UIButton *)[self.topView viewWithTag:tag];
    [self categoryButtonAction:selectBut];
}

@end
