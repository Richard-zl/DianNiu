//
//  DNQ_ADetailViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/12/14.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNQ_ADetailViewC.h"
#import "DNQ_ADetailHederView.h"
#import "DNAnswerCell.h"
#import "DNAnswerViewModel.h"
#import "DNUserDetailC.h"
#import "DNCollectRequest.h"
#import "DNAddAnswerRequest.h"
#import "DNInformationViewC.h"

@interface DNQ_ADetailViewC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *commentTf;
@property (weak, nonatomic) IBOutlet UIButton *commentBut;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentViewBottomCons;


@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<DNAnswerViewModel *>* dataSource;

@end

@implementation DNQ_ADetailViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查看问答";
    [self configurSubViews];
}

- (void)configurSubViews{
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.commentBut.superview];
    [self configurTableView];
    [self configurMjrefresh];
    [self creatRightCollecBut];
    [self registerNotification];
}

- (void)creatRightCollecBut{
    if (self.type == DNHomeListType_questions) {
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sandian"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightButAction)];
        rightItem.tintColor = [UIColor whiteColor];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
}

- (void)configurTableView{
    DNQ_ADetailHederView *hederView = [[[NSBundle mainBundle] loadNibNamed:@"DNQ_ADetailHederView" owner:nil options:nil] firstObject];
    hederView.didClickDetailView = ^{
        if ([_q_aModel.q_aModel.accountId integerValue] == [[DNUser sheared].userId integerValue]) {
            //我的资料
            DNInformationViewC *infoC = [[DNInformationViewC alloc] init];
            [self.navigationController pushViewController:infoC animated:YES];
        }else{
            [self pushUserDetailCWithAccountId:self.q_aModel.q_aModel.accountId];
        }
    };
    hederView.type = self.type;
    hederView.model = self.q_aModel;
    [self.tableView setTableHeaderView:hederView];
    self.tableView.estimatedRowHeight = 80.0;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)configurMjrefresh{
    DNAnswerListRequest *request = [[DNAnswerListRequest alloc] init];
    request.accountId = self.q_aModel.q_aModel.accountId;
    request.questId   = self.q_aModel.q_aModel.q_aId;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        request.page = 0;
        [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
            [self.tableView.mj_header endRefreshing];
            [self.dataSource removeAllObjects];
            NSArray *listArray = respondObj[@"list"];
            if (listArray.count != 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary *dict in listArray) {
                DNAnswerViewModel *viewModel = [[DNAnswerViewModel alloc] initWhitDictionary:dict];
                [self.dataSource addObject:viewModel];
            }
            [self.tableView reloadData];
        } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
            //基类已经做了处理
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    ((MJRefreshNormalHeader *)self.tableView.mj_header).lastUpdatedTimeLabel.hidden = YES;
    ((MJRefreshNormalHeader *)self.tableView.mj_header).stateLabel.hidden = YES;
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        request.page = self.dataSource.count;
        [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
            [self.tableView.mj_header endRefreshing];
            NSArray *listArray = respondObj[@"list"];
            if (listArray.count == 20) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }else{
                [self.tableView.mj_footer resetNoMoreData];
            }
            for (NSDictionary *dict in listArray) {
                DNAnswerViewModel *viewModel = [[DNAnswerViewModel alloc] initWhitDictionary:dict];
                [self.dataSource addObject:viewModel];
            }
            [self.tableView reloadData];
        } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
            //基类已经做了处理
            [self.tableView.mj_header endRefreshing];
        }];
    }];
    [((MJRefreshNormalHeader *)self.tableView.mj_footer) setTitle:@"" forState:MJRefreshStateNoMoreData];
}

- (void)registerNotification{
    DNListenEvent(UIKeyboardWillShowNotification, self, @selector(changeContentViewPosition:));
    DNListenEvent(UIKeyboardWillHideNotification, self, @selector(changeContentViewPosition:));
}

#pragma mark - private
- (void)pushUserDetailCWithAccountId:(NSNumber *)accountId{
    if (self.type == DNHomeListType_questions) {
        DNUserDetailC *detailC = [[DNUserDetailC alloc] initWithNibName:@"DNUserDetailC" bundle:nil];
        detailC.accountId = accountId;
        [self.navigationController pushViewController:detailC animated:YES];
    }
}
- (void)addAnserRequest{
    DNAddAnswerRequest *request = [[DNAddAnswerRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.questId   = self.q_aModel.q_aModel.q_aId;
    request.content   = self.commentTf.text;
    [SVProgressHUD showWithStatus:@"正在评论..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        self.commentTf.text = @"";
        [self resignCommentTfFirstResponder];
        [self.tableView.mj_header beginRefreshing];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}
- (void)resignCommentTfFirstResponder{
    if ([self.commentTf isFirstResponder]) {
        [self.commentTf resignFirstResponder];
    }
}

#pragma mark -Event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self resignCommentTfFirstResponder];
}

- (void)navigationRightButAction{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"收藏",nil];
    [sheet bk_setDidDismissBlock:^(UIActionSheet *actionSheet, NSInteger index) {
        if ([actionSheet cancelButtonIndex] != index) {
            DNCollectRequest *request = [[DNCollectRequest alloc] init];
            request.accountId = [DNUser sheared].userId;
            request.questId   = self.q_aModel.q_aModel.q_aId;
            [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
                [SVProgressHUD showSuccessWithStatus:@"收藏成功"];
            } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
               //基类已经处理
            }];
        };
    }];
    [sheet showInView:self.view];
}
- (IBAction)commentButtonAction:(id)sender {
    if (self.type == DNHomeListType_questions && [DNUser sheared].authLevel < DNUSerAuthLevel_ONE) {
        [self resignCommentTfFirstResponder];
        self.commentTf.text = @"";
        //没有权限评论电钮问答 只能评论匿名
        DNTextAlert(nil, @"您还未完成认证，请先验证！", @[@"确认",@"取消"], ^(NSInteger index) {
            if (index == 0) {
                //跳转权限认证
                DNInformationViewC *viewC = [[DNInformationViewC alloc] initWithNibName:@"DNInformationViewC" bundle:[NSBundle mainBundle]];
                [self.navigationController pushViewController:viewC animated:YES];
            }
        });
        return;
    }
    [self addAnserRequest];
}

- (void)changeContentViewPosition:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value         = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat keyBoardEndY   = value.CGRectValue.origin.y;
    CGFloat duration       = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    if (ScreenHeight != keyBoardEndY) {
        //键盘弹起
        self.commentViewBottomCons.constant = value.CGRectValue.size.height;
    }else{
        //键盘收起
        self.commentViewBottomCons.constant = 0.0;
    }
    [UIView animateWithDuration:duration animations:^{
        [self.commentBut.superview setNeedsLayout];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.dataSource[indexPath.row].cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DNAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNAnswerCell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DNAnswerCell class]) owner:nil options:nil] firstObject];
    }
    cell.type      = self.type;
    DNAnswerViewModel *anserModel = self.dataSource[indexPath.row];
    cell.viewModel = anserModel;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource[indexPath.row].accountId integerValue] == [[DNUser sheared].userId integerValue]) {
        //我的资料
        DNInformationViewC *infoC = [[DNInformationViewC alloc] init];
        [self.navigationController pushViewController:infoC animated:YES];
    }else{
        [self pushUserDetailCWithAccountId:self.dataSource[indexPath.row].accountId];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self resignCommentTfFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    self.commentBut.enabled = textView.text.length > 0;
}

#pragma mark - getter and setter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,64, ScreenWidth, ScreenHeight - 64 - self.commentTf.superview.height) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (NSMutableArray<DNAnswerViewModel *> *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
