//
//  DNHomeViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNHomeViewC.h"
#import "DNDianniuQ_ATableViewC.h"
#import "DNAnonymityQ_ATableViewC.h"
#import "DNPicturebrowsingC.h"
#import "DNHomeListRequestModel.h"
#import "DNHomeButton.h"
#import "DNDianniuQ_AViewModel.h"
#import "DNAddQuestionView.h"


#define DNHomeNavigationBarHeight 74
@interface DNHomeViewC () <DNHomeRequestDelegate>
@property (weak, nonatomic) IBOutlet DNHomeButton *firstBut;
@property (weak, nonatomic) IBOutlet DNHomeButton *secondBut;

@property (nonatomic, strong) DNDianniuQ_ATableViewC   *dianniuTableViewC; //电钮问答控制器
@property (nonatomic, strong) DNAnonymityQ_ATableViewC *anonymitTableViewC;//匿名问答控制器
@property (nonatomic, strong) UITableViewController    *currentVC;         //当前正在显示的控制器
@end

@implementation DNHomeViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
    [self listeningNotice];
    [self requestHomeListWithPage:0 counts:20 listType:1 successBlock:nil faledBlock:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_firstBut.enabled && _secondBut.enabled) {
        self.firstBut.enabled = NO;
        [self.view addSubview:self.dianniuTableViewC.view];
        self.currentVC = self.dianniuTableViewC;
    }
}

#pragma mark - UI Mehoed
- (void)configurSubViews{
    [self addChildViewController:self.dianniuTableViewC];
    [self addChildViewController:self.anonymitTableViewC];
}
//  切换各个标签内容
- (void)replaceController:(UITableViewController *)oldController newController:(UITableViewController *)newController
{
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.4 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
        }else{
            self.currentVC = oldController;
        }
    }];
}

- (CGRect)tableViewRect{
   return CGRectMake(0,
               DNHomeNavigationBarHeight,
               ScreenWidth,
               ScreenHeight - DNHomeNavigationBarHeight - self.tabBarController.tabBar.height);
}

- (void)reSetHomeButtonState{
    if (_firstBut.enabled) {
        //点的 电钮问答
        _firstBut.enabled  = NO;
        _secondBut.enabled = YES;
    }else{
        //点的 匿名问答
        _secondBut.enabled = NO;
        _firstBut.enabled  = YES;
    }
}

#pragma mark - private
- (void)requestHomeListWithPage:(NSInteger)page counts:(NSInteger)counts listType:(DNHomeListType)type successBlock:(DNNetWorkSuccess)succblock faledBlock:(DNNetWorkFailed)failed{
    DNHomeListRequestModel *model = [[DNHomeListRequestModel alloc] init];
    model.page   = @(page);
    model.counts = @(counts);
    model.type   = type;
    if (page == 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    }
    [model httpRequest:30 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        NSMutableDictionary *dataSource   = [NSMutableDictionary dictionary];
        NSMutableArray      *contentArray = [NSMutableArray array];
        NSMutableArray      *hotContArray = [NSMutableArray array];
        for (NSDictionary *dataDict in respondObj) {
            DNDianniuQ_AModel     *model     = [DNDianniuQ_AModel modelWithQ_ADictionary:dataDict];
            DNDianniuQ_AViewModel *ViewModel = [[DNDianniuQ_AViewModel alloc] initWithQ_AModel:model];
            if (ViewModel.q_aModel.top) {
                [hotContArray addObject:ViewModel];
            }else{
                [contentArray addObject:ViewModel];
            }
        }
        [dataSource setValue:contentArray forKey:@"content"];
        [dataSource setValue:hotContArray forKey:@"hotContent"];
        if (type == DNHomeListType_questions) {
            //电钮问答
            [self.dianniuTableViewC tableViewNeedReload:dataSource isRefresh:(page == 0)];
        }else{
            //匿名问答
            [self.anonymitTableViewC tableViewNeedReload:dataSource isRefresh:(page == 0)];
        }
        if (succblock) {
            succblock(sessionTask,respondObj);
        }

    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        //基类已经做过处理
        if (failed) {
            failed(sessionTask,nil);
        }
    }];
}

#pragma mark -notice
- (void)listeningNotice{
    DNListenEvent(kDNKeyNoticeShowImage, self, @selector(showContentImage:));
}

#pragma mark - Event
///主页问题切换按钮点击事件
- (IBAction)requestButtonAction:(UIButton *)sender {
    [self requestHomeListWithPage:0 counts:20 listType:sender.tag successBlock:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [self reSetHomeButtonState];
        UITableViewController *newC = [self.currentVC isEqual:self.dianniuTableViewC] ? self.anonymitTableViewC : self.dianniuTableViewC;
        [self replaceController:self.currentVC newController:newC];
    } faledBlock:nil];
}

//发布按钮点击事件
- (IBAction)postButtonAction:(id)sender {
    DNAddQuestionView *view = [[DNAddQuestionView alloc] initWithClickIndex:^(DNHomeListType type) {
        
    }];
    [DNSharedDelegate.window addSubview:view];
    [view show];
}


- (void)showContentImage:(NSNotification *)notification{
    NSArray     *dataSource = [notification.object objectForKey:@"DNImageURLStrings"];
    NSIndexPath *indexPath  = [notification.object objectForKey:@"indexPath"];
    DNPicturebrowsingC *picC = [[DNPicturebrowsingC alloc] initWithDatasource:dataSource andIndex:indexPath];
    [self presentViewController:picC animated:YES completion:^{
        
    }];
}

#pragma mark - 请求数据代理方法
- (void)refreshRequestWithPage:(NSInteger)page counts:(NSInteger)count type:(DNHomeListType)type finish:(void (^)())finishBlock{
    [self requestHomeListWithPage:page counts:count listType:type successBlock:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        if (finishBlock) {
            finishBlock();
        }
    } faledBlock:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        if (finishBlock) {
            finishBlock();
        }
    }];
}

#pragma mark - getter and setter
- (DNDianniuQ_ATableViewC *)dianniuTableViewC{
    if (!_dianniuTableViewC) {
        _dianniuTableViewC = [[DNDianniuQ_ATableViewC alloc] init];
        _dianniuTableViewC.type = DNHomeListType_questions;
        _dianniuTableViewC.requestdelegate = self;
        _dianniuTableViewC.view.frame = [self tableViewRect];
    }
    return _dianniuTableViewC;
}

- (DNAnonymityQ_ATableViewC *)anonymitTableViewC{
    if (!_anonymitTableViewC) {
        _anonymitTableViewC = [[DNAnonymityQ_ATableViewC alloc] init];
        _anonymitTableViewC.type = DNHomeListType_anonymity;
        _anonymitTableViewC.requestdelegate = self;
        _anonymitTableViewC.view.frame = [self tableViewRect];
    }
    return _anonymitTableViewC;
}


@end
