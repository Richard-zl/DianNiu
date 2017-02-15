//
//  DNRecruitDetailViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitDetailViewC.h"
#import "DNRecruitDetailRequest.h"
#import "DNUserCell.h"
#import "DNRecruitPostCell.h"
#import "DNRecruitInfoCell.h"
#import "DNRecruitDesciptionCell.h"
#import "DNRecruitAddRequest.h"

@interface DNRecruitDetailViewC ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bottomBut;
@property (nonatomic, strong) NSMutableDictionary *dataSource;

@end

@implementation DNRecruitDetailViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
    [self requestRecruitDetail];
    
}

- (void)dealloc{
    NSLog(@"求职详情页面被销毁了");
}

#pragma mark UI Metheod
- (void)configurSubViews{
    [self configurTableViews];
    if (self.type == DNRecruitDetailType_RECRUIT) {
        self.title = @"招聘详情";
    }else{
        self.title = @"求职详情";
    }
}

- (void)creatRightCollecBut{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"sandian"] style:UIBarButtonItemStylePlain target:self action:@selector(navigationRightButAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configurTableViews{
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"DNRecruitPostCell" bundle:nil] forCellReuseIdentifier:@"DNRecruitPostCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DNUserCell" bundle:nil] forCellReuseIdentifier:@"DNUserCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DNRecruitInfoCell" bundle:nil] forCellReuseIdentifier:@"RecruitInfoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DNRecruitDesciptionCell" bundle:nil] forCellReuseIdentifier:@"DNDescriptionCell"];
    self.tableView.estimatedRowHeight = 80.0;
}

#pragma mark - private

- (void)changeBottomButtonStats{
    NSInteger stats = [[self.dataSource DNObjectForKey:@"status"] integerValue];
    NSInteger accountId = [[self.dataSource DNObjectForKey:@"accountId"] integerValue];
    if ([[DNUser sheared].userId integerValue] == accountId) {
        //当前用户发的招聘/求职
        NSString *typeStr = self.type == DNRecruitDetailType_JOB ? @"求职":@"招聘";
        [self.bottomBut setTitle:[NSString stringWithFormat:@"删除本条%@",typeStr] forState:UIControlStateNormal];
    }else{
        //不是当前用户发出的招聘／求职
        if (stats == 0) {
            //未申请
            [self.bottomBut setTitle:@"申请" forState:UIControlStateNormal];
            [self.bottomBut setTitle:@"已申请" forState:UIControlStateSelected];
        }else{
            //已申请
            [self.bottomBut setTitle:@"已申请" forState:UIControlStateSelected];
            self.bottomBut.selected = YES;
            self.bottomBut.userInteractionEnabled = NO;
        }
    }
}

- (CGFloat)cellHeightWithSection:(NSInteger)section{
    CGFloat height = 0;
    BOOL isJobType = self.type == DNRecruitDetailType_JOB;
    switch (section) {
        case 0:
            height = 40;
            break;
        case 1:
            height = isJobType ? 60 : 120;
            break;
        case 2:
            height = isJobType ? 120 : self.tableView.height - 40 - 120;
            break;
        case 3:
            height = self.tableView.height - 40 - 60 - 120;
            break;
    }
    return height;
}

#pragma mark - private
- (void)requestRecruitDetail{
    DNRecruitDetailRequest *detailRequest = [[DNRecruitDetailRequest alloc] init];
    detailRequest.requestId = self.requestId;
    detailRequest.type = self.type;
    detailRequest.accountId = [DNUser sheared].userId;
    [SVProgressHUD showWithStatus:@"正在加载..."];
    [detailRequest httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        self.dataSource = [respondObj mutableCopy];
        [self changeBottomButtonStats];
        [self.tableView reloadData];
    } failed:nil];
}

- (void)requestRecruitAdd{
    DNRecruitAddRequest *addRequest = [[DNRecruitAddRequest alloc] init];
    addRequest.requestId = self.requestId;
    addRequest.type = self.type;
    addRequest.accountId = [DNUser sheared].userId;
    addRequest.content = @"";
    [addRequest httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [self.bottomBut setTitle:@"已申请" forState:UIControlStateSelected];
        self.bottomBut.userInteractionEnabled = NO;
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        self.bottomBut.selected = NO;
    }];
}

#pragma mark - Event
- (void)navigationRightButAction{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"申请用户列表", nil];
    [sheet bk_setDidDismissBlock:^(UIActionSheet *actionSheet, NSInteger index) {
        if (index != [actionSheet cancelButtonIndex]) {
            //用户申请列表
            DNAlert(nil, @"申请用户列表", @"确定", nil);
        }
    }];
    [sheet showInView:self.view];
}

- (IBAction)bottomButtonAction:(UIButton *)sender {
    if (sender.isSelected) {
        return;
    }
    NSInteger accountId = [[self.dataSource DNObjectForKey:@"accountId"] integerValue];
    if ([[DNUser sheared].userId integerValue] == accountId) {
        //删除请求
        [self.bottomBut setTitle:@"删除中..." forState:UIControlStateSelected];
    }else{
        [self.bottomBut setTitle:@"申请中..." forState:UIControlStateSelected];
        [self requestRecruitAdd];
    }
    sender.selected = YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataSource) {
        return 0;
    }
    if (self.type == DNRecruitDetailType_JOB) {
        return 4;
    }else{
        return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self cellHeightWithSection:indexPath.section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    //先设置type 再设置dataSource
    BOOL isJobType = self.type == DNRecruitDetailType_JOB;
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"DNRecruitPostCell" forIndexPath:indexPath];
            ((DNRecruitPostCell *)cell).type = self.type;
            ((DNRecruitPostCell *)cell).dataSource = self.dataSource;
            break;
        case 1:
            if (isJobType) {
                DNUserCell *usercell = [tableView dequeueReusableCellWithIdentifier:@"DNUserCell" forIndexPath:indexPath];
                usercell.userDic = self.dataSource;
                cell = usercell;
            }else{
                DNRecruitInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"RecruitInfoCell" forIndexPath:indexPath];
                infoCell.type = self.type;
                infoCell.dataSource = self.dataSource;
            }
            break;
        case 2:
            if (isJobType) {
                DNRecruitInfoCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"RecruitInfoCell" forIndexPath:indexPath];
                infoCell.type = self.type;
                infoCell.dataSource = self.dataSource;
            }else{
                DNRecruitDesciptionCell *desriptionCell = [tableView dequeueReusableCellWithIdentifier:@"DNDescriptionCell" forIndexPath:indexPath];
                desriptionCell.type = self.type;
                desriptionCell.dataSource = self.dataSource;
            }
            break;
        case 3:
        {
            DNRecruitDesciptionCell *desriptionCell = [tableView dequeueReusableCellWithIdentifier:@"DNDescriptionCell" forIndexPath:indexPath];
            desriptionCell.type = self.type;
            desriptionCell.dataSource = self.dataSource;
        }
            break;
    }
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
