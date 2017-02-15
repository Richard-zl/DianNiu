//
//  DNReleaseActivityViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/14.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNReleaseActivityViewC.h"
#import "DNSingleSelectControl.h"
#import "DNDateSelectControl.h"

@interface DNReleaseActivityViewC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *titleArr;
@property (nonatomic, strong) NSMutableDictionary *keyDict;
@property (nonatomic, strong) DNSingleSelectControl *numberSlectControl;
@property (nonatomic, strong) DNDateSelectControl *dateControl;

@property (nonatomic, weak) UITextField *titleTf;
@property (nonatomic, weak) UIButton *typeButton;
@property (nonatomic, weak) UITextField *amountTf;
@property (nonatomic, weak) UITextView *textView;
@end

@implementation DNReleaseActivityViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"创建活动";
    [self configurSubViews];
}

- (void)dealloc{
    NSLog(@"发布活动页面被销毁");
}

#pragma mark - UI Method

- (void)configurSubViews{
    [self configurTableView];
    [self.view addSubview:self.numberSlectControl];
    [self.view addSubview:self.dateControl];
}

- (void)configurTableView{
    self.tableView.backgroundColor = RGBColor(241, 241, 241);
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[DNReleaseActiTextCell class] forCellReuseIdentifier:@"DNTextCell"];
}

#pragma mark - private
//显示人数选择器
- (void)showNumberControl{
    [self.numberSlectControl showData:@[@"1人",@"2-3人",@"3-5人",@"5-8人",@"8-10人"] andParam:0];
}

#pragma mark - Event
- (IBAction)releaseButtonAction:(UIButton *)sender {
  
}

- (void)typeButtonAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    if (self.titleArr.count < 8) {
        [self.titleArr insertObject:@"花费" atIndex:5];
    }else{
        [self.titleArr removeObjectAtIndex:5];
    }
    [self.tableView reloadData];
}

//人数回调
- (void(^)(NSString *value,DNReleaseRecruitParam param))didSelectedNumber{
    DNWeakself
    return ^(NSString *value,DNReleaseRecruitParam param){
        if (value.length > 0) {
            [weakSelf.keyDict setObject:value forKey:@"人数"];
            [weakSelf.tableView reloadData];
        }
    };
}

//日期回调
- (void(^)(NSString *dateStr))didSelectedDate{
    DNWeakself
    return ^(NSString *dateStr){
        if (dateStr.length > 0) {
            [weakSelf.keyDict setObject:dateStr forKey:@"时间"];
            [weakSelf.tableView reloadData];
        }
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.titleArr.count - 1) {
        return 120;
    }
    return 45.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNActivityNorCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DNActivityNorCell"];
    }
    UITextField *titleTf = [cell.contentView viewWithTag:500];
    UIButton *   button  = [cell.contentView viewWithTag:501];
    UITextField *amountTf = [cell.contentView viewWithTag:502];
    amountTf.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.detailTextLabel.text = @"";
    if (indexPath.row < self.titleArr.count) {
        NSString *title = self.titleArr[indexPath.row];
        cell.textLabel.text = title;
        if ([title isEqualToString:@"人数"] ||
            [title isEqualToString:@"时间"] ||
            [title isEqualToString:@"地点"] ||
            [title isEqualToString:@"报名要求"]) {
            cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
            cell.detailTextLabel.text = [self.keyDict DNObjectForKey:title];
        }else if ([title isEqualToString:@"主题"]){
            if (!titleTf) {
                CGFloat x = 100.0;
                titleTf = [[UITextField alloc] initWithFrame:CGRectMake(x, 0, ScreenWidth - x - 8, 45)];
                titleTf.placeholder = @"输入活动主题";
                titleTf.tag = 500;
                [cell.contentView addSubview:titleTf];
            }
            self.titleTf = titleTf;
        }else if ([title isEqualToString:@"费用"]){
            if (!button) {
                CGFloat width = 75.0; CGFloat height = 25.0;
                button = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - width - 10, (45 - height)/2, width, height)];
                [button setBackgroundImage:[UIImage imageNamed:@"activity_checkbox_nor"] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"activity_checkbox_press"] forState:UIControlStateSelected];
                [button addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = 501;
                [cell.contentView addSubview:button];
            }
            self.typeButton = button;
        }else if ([title isEqualToString:@"花费"]){
            cell.detailTextLabel.text = @"元/每人";
            cell.detailTextLabel.textColor = [UIColor blackColor];
            if (!amountTf) {
                amountTf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth - 80 - 75, 0, 75, 45)];
                amountTf.placeholder = @"输入金额";
                amountTf.tag = 502;
                amountTf.keyboardType = UIKeyboardTypeNumberPad;
                [cell.contentView addSubview:amountTf];
            }
            amountTf.hidden = NO;
            self.amountTf = amountTf;
        }else if ([title isEqualToString:@"活动内容简介"]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"DNTextCell" forIndexPath:indexPath];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row < self.titleArr.count) {
        NSString *title = self.titleArr[indexPath.row];
        if ([title isEqualToString:@"人数"]){
            [self showNumberControl];
        }else if ([title isEqualToString:@"时间"]){
            [self.dateControl show];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.tableView endEditing:YES];
}

#pragma mark - getter
- (NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = [@[@"主题",@"人数",@"时间",@"地点",@"费用",@"报名要求",@"活动内容简介",] mutableCopy] ;
    }
    return _titleArr;
}

- (NSMutableDictionary *)keyDict{
    if (!_keyDict) {
        _keyDict = [@{@"人数":@"必填",@"时间":@"选择活动开始时间",@"地点":@"活动地点",@"报名要求":@"必填"} mutableCopy];
    }
    return _keyDict;
}

- (DNSingleSelectControl *)numberSlectControl{
    if (!_numberSlectControl) {
        _numberSlectControl = [[DNSingleSelectControl alloc] init];
        _numberSlectControl.selectedBlock = [self didSelectedNumber];
    }
    return _numberSlectControl;
}

- (DNDateSelectControl *)dateControl{
    if (!_dateControl) {
        _dateControl = [[DNDateSelectControl alloc] init];
        _dateControl.didSelected = [self didSelectedDate];
    }
    return _dateControl;
}

@end

@interface DNReleaseActiTextCell ()<UITextViewDelegate>
@property (nonatomic, strong)UILabel *tipLabel;
@end

@implementation DNReleaseActiTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self creatSubViews];
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
        [self creatSubViews];
    }
    return self;
}

- (void)creatSubViews{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 180, 20)];
    titleLabel.text = @"活动内容简介";
    [self.contentView addSubview:titleLabel];
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(15, titleLabel.bottom + 10, ScreenWidth - 30, 120 - titleLabel.bottom - 10)];
    self.textView.font = [UIFont systemFontOfSize:16];
    self.textView.delegate = self;
    [self.contentView addSubview:self.textView];
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, _textView.top + 6, _textView.width - 5, 80)];
    self.tipLabel.numberOfLines = 2;
    self.tipLabel.text = @"输入活动内容概况，开启电纽线下之路！";
    self.tipLabel.textColor = [UIColor darkGrayColor];
    self.tipLabel.height = [self.tipLabel.text boundingRectWithSize:self.tipLabel.size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.tipLabel.font} context:nil].size.height;
    [self.contentView addSubview:self.tipLabel];
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.tipLabel.hidden = YES;
    }else{
        self.tipLabel.hidden = NO;
    }
}

@end

