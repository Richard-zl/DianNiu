//
//  DNProfileViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/25.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNProfileViewC.h"
#import "DNInformationViewC.h"

#define DNProfileCellIdentifier @"DNProfileCell"
@interface DNProfileViewC ()<UITableViewDataSource,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nicknameLb;
@property (weak, nonatomic) IBOutlet UILabel *dianniuIdLb;
@property (weak, nonatomic) IBOutlet UILabel *signtureLb;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet UIView *tipView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipViewHeightCons;

@end

@implementation DNProfileViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configurProfile];
}

#pragma mark - UI Methodes
- (void)configurSubViews{
    self.tableview.tableFooterView = [UIView new];
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:DNProfileCellIdentifier];
    [self configurProfile];
}

- (void)configurProfile{
    self.nicknameLb.text  = [DNUser sheared].realName.length > 0 ? [DNUser sheared].realName : @"";
    self.dianniuIdLb.text = [DNUser sheared].userId ? [[DNUser sheared].userId description] : @"";
    self.signtureLb.text  = [DNUser sheared].userDesription.length > 0 ? [DNUser sheared].userDesription : @"";
    if ([DNUser sheared].authLevel < DNUSerAuthLevel_ONE) {
        //一级认证都没有,需要展示提示视图
        self.tipView.hidden = NO;
        self.tipViewHeightCons.constant = 65.0;
    }else{
        //最少过了一级认证，不需要展示提示视图
        self.tipView.hidden = YES;
        self.tipViewHeightCons.constant = 0;
    }
}

#pragma mark - Event
- (IBAction)needGoInfomationView:(id)sender {
    DNInformationViewC *viewC = [[DNInformationViewC alloc] initWithNibName:@"DNInformationViewC" bundle:[NSBundle mainBundle]];
    [self.navigationController pushViewController:viewC animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGB(0xefefef);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DNProfileCellIdentifier];
    NSString *title,*imageName = @"";
    switch (indexPath.row) {
        case 0:
            if (indexPath.section == 0) {
                //第一个
                title = @"我的收藏";
                imageName = @"setting_collection_icon";
                cell.textLabel.textColor = UIColorFromRGB(0x63AB34);
            }else{
                //第三个
                title = @"设置";
                imageName = @"setting_sets_icon";
            }
            break;
        case 1:
            if (indexPath.section == 0) {
                //第二个
                title = @"与我相关";
                imageName = @"settting_my_icon";
                cell.textLabel.textColor = UIColorFromRGB(0xFA1914);
            }else{
                //第四个
                title = @"联系客服";
                imageName = @"settting_contact_icon";
            }
            break;
    }
    cell.textLabel.text = title;
    cell.imageView.image = [UIImage imageNamed:imageName];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell.textLabel.text isEqualToString:@"我的收藏"]) {
        
    }else if ([cell.textLabel.text isEqualToString:@"与我相关"]){
        
    }else if ([cell.textLabel.text isEqualToString:@"设置"]){
        
    }else if ([cell.textLabel.text isEqualToString:@"联系客服"]){
        
    }
}

@end
