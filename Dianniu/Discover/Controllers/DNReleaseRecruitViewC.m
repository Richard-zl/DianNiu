//
//  DNReleaseRecruitViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/2/7.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNReleaseRecruitViewC.h"
#import "DNSingleSelectControl.h"
#import "DNSelectControl.h"
#import "DNAddJobRecruitRequest.h"

#define DNReleaseRecruitKeyTag 200
#define DNReleaseRecruitValueTag 500
#define DNSubViewHeight 45

@interface DNReleaseRecruitViewC ()<UIScrollViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property (nonatomic, strong)NSMutableArray *cellKeyArr;
@property (nonatomic, strong)NSMutableArray *cellValueArr;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UISwitch* tryoutSwith;
@property (nonatomic, strong)UITextField *numberTf;
@property (nonatomic, strong)UITextView *descriptionTextView;
@property (nonatomic, strong)UITextView *contactTextView;
@property (nonatomic, strong)DNSingleSelectControl *paramSelectControl;
@property (nonatomic, strong)DNSelectControl *areaSelectControl;
@end

@implementation DNReleaseRecruitViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubViews];
    [self didSelectedParam];
    [self didSelectedArar];
}

#pragma mark UI Method
- (void)configurSubViews{
    if (_releaseType == DNRecruitDetailType_JOB) {
        self.title = @"求职发布";
    }else{
        self.title = @"招聘发布";
    }
    [self creatNaviRightButton];
    [self configurScrollView];
    [self configurCellView];
}

- (void)dealloc{
    NSLog(@"发布页面销毁");
}

- (void)creatNaviRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(releaseButtonAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configurScrollView{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    self.scrollView.backgroundColor = RGBColor(247, 247, 247);
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.paramSelectControl];
    [self.scrollView addSubview:self.areaSelectControl];
    if (ScreenHeight < 480) {
        self.scrollView.contentSize = CGSizeMake(ScreenHeight, 480);
    }
}

- (void)configurCellView{
    [self.cellKeyArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx <= 5) {
            UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, idx *DNSubViewHeight, ScreenWidth, DNSubViewHeight)];
            [self.scrollView addSubview:subView];
            UIButton *actionBut = [[UIButton alloc] initWithFrame:subView.bounds];
            actionBut.backgroundColor = [UIColor clearColor];
            actionBut.tag = DNReleaseRecruitKeyTag + idx;
            [actionBut addTarget:self action:@selector(paramButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [subView addSubview:actionBut];
            UILabel *keyLb = [[UILabel alloc] initWithFrame:CGRectZero];
            keyLb.text = obj;
            [keyLb sizeToFit];
            keyLb.left = 15; keyLb.top = 0; keyLb.height = DNSubViewHeight;
            [subView addSubview:keyLb];
            if (idx == 2) {
                //第3个参数
                [actionBut removeFromSuperview];
                self.tryoutSwith = [[UISwitch alloc] init];
                self.tryoutSwith.top = (DNSubViewHeight - self.tryoutSwith.height)/2;
                self.tryoutSwith.left = ScreenWidth - self.tryoutSwith.width - 15;
                [subView addSubview:self.tryoutSwith];
            }else if(_releaseType == DNRecruitDetailType_RECRUIT && idx == 4){
                //招聘发布的第四个参数应该是人数
                [actionBut removeFromSuperview];
                self.numberTf = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth - 100, 0, 70, 45)];
                self.numberTf.top = (DNSubViewHeight - self.numberTf.height)/2;
                self.numberTf.keyboardType = UIKeyboardTypeNumberPad;
                self.numberTf.delegate = self;
                self.numberTf.placeholder = @"填写人数";
                self.numberTf.inputAccessoryView = [self creatAccessoryView];
                [subView addSubview:self.numberTf];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_numberTf.right, 0, 30, DNSubViewHeight)];
                label.text = @"人";
                [subView addSubview:label];
            }else{
                UILabel *valueLb = [[UILabel alloc] initWithFrame:CGRectMake(keyLb.right+5, 0, ScreenWidth - keyLb.right -5 - 16, DNSubViewHeight)];
                valueLb.textAlignment = NSTextAlignmentRight;
                valueLb.textColor = RGBColor(88, 88, 88);
                valueLb.text = self.cellValueArr[idx];
                valueLb.tag = DNReleaseRecruitValueTag + idx;
                [subView addSubview:valueLb];
                UIImageView *rightImgView = [[UIImageView alloc] initWithFrame:CGRectMake(valueLb.right+4, (DNSubViewHeight - 15)/2, 8, 15)];
                rightImgView.image = [UIImage imageNamed:@"set_right_icon"];
                [subView addSubview:rightImgView];
            }
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0,DNSubViewHeight-1,ScreenWidth, 1)];
            lineView.backgroundColor = RGBColor(233, 233, 233);
            [subView addSubview:lineView];
        }else{
            UILabel *desriptionLb = [[UILabel alloc] initWithFrame:CGRectMake(15, 6*DNSubViewHeight, ScreenWidth, DNSubViewHeight)];
            if (self.releaseType == DNRecruitDetailType_JOB) {
                desriptionLb.text = @"个人描述";
            }else{
                desriptionLb.text = @"职位描述";
            }
            [self.scrollView addSubview:desriptionLb];
            self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, desriptionLb.bottom, ScreenWidth - 30, 60)];
            self.descriptionTextView.backgroundColor = self.scrollView.backgroundColor;
            self.descriptionTextView.delegate = self;
            self.descriptionTextView.inputAccessoryView = [self creatAccessoryView];
            [self.scrollView addSubview:self.descriptionTextView];
            
            UILabel *contactLb = [[UILabel alloc] initWithFrame:CGRectMake(15, self.descriptionTextView.bottom, ScreenWidth, DNSubViewHeight)];
            contactLb.text = @"联系方式";
            self.contactTextView = [[UITextView alloc] initWithFrame:CGRectMake(15, contactLb.bottom, self.descriptionTextView.width, _descriptionTextView.height)];
            self.contactTextView .backgroundColor = self.scrollView.backgroundColor;
            self.contactTextView.delegate = self;
            self.contactTextView.inputAccessoryView = [self creatAccessoryView];
            [self.scrollView addSubview:contactLb];
            [self.scrollView addSubview:self.contactTextView];
            *stop = YES;
        }
    }];
}

- (UIView *)creatAccessoryView{
    UIButton *accessoryView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    [accessoryView setTitle:@"收起键盘" forState:UIControlStateNormal];
    [accessoryView setTitleColor:DNThemeColor forState:UIControlStateNormal];
    accessoryView.backgroundColor = [UIColor lightGrayColor];
    [accessoryView addTarget:self action:@selector(dismissKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    return accessoryView;
}

#pragma mark - Event
- (void)releaseButtonAction{
    if (![self verifyParam]) {
        [SVProgressHUD showErrorWithStatus:@"请填写完整"];
        return;
    }
    DNAddJobRecruitRequest *request = [[DNAddJobRecruitRequest alloc] init];
    request.type = self.releaseType;
    request.accountId = [DNUser sheared].userId;
    request.post = self.cellValueArr[DNReleaseRecruitParam_Post];
    request.salary = self.cellValueArr[DNReleaseRecruitParam_Salary];
    request.tryout = @(!self.tryoutSwith.isSelected);
    request.area   = self.cellValueArr[DNReleaseRecruitParam_Area];
    if (self.releaseType == DNRecruitDetailType_JOB) {
        request.experience = self.cellValueArr[DNReleaseRecruitParam_Experience];
    }else{
        request.recruitNumber = @([self.numberTf.text integerValue]);
    }
    request.education = self.cellValueArr[DNReleaseRecruitParam_Education];
    request.describe = self.descriptionTextView.text;
    request.contact = self.contactTextView.text;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:nil];
    
}

- (void)paramButtonAction:(UIButton *)target{
    target.backgroundColor = RGBColor(200, 200, 200);
    [UIView animateWithDuration:0.5 animations:^{
        target.backgroundColor = [UIColor clearColor];
    }];
    NSInteger tag = target.tag - DNReleaseRecruitKeyTag;
    NSArray *params;
    switch (tag) {
        case DNReleaseRecruitParam_Post:
            params = @[@"运营",@"客服",@"店长",@"售后",@"仓管",@"其他"];
            break;
        case DNReleaseRecruitParam_Salary:
            params = @[@"面议",@"3000及以下/月",@"3000-5000/月",@"5000-7000/月",@"7000-10000/月",@"10000-15000/月",@"15000-20000/月",@"20000以上/月"];
            break;
        case DNReleaseRecruitParam_Area:
            [self.areaSelectControl show];
            return;
            break;
        case DNReleaseRecruitParam_Experience:
            params = @[@"一年以下",@"1-3年",@"3-5年",@"5-10年",@"10年以上"];
            break;
        case DNReleaseRecruitParam_Education:
            params = @[@"不限",@"高中及以上",@"专科及以上",@"本科及以上",@"硕士及以上",@"博士及以上"];
            break;
    }
    [self.paramSelectControl showData:params andParam:tag];
}

- (void)didSelectedParam{
    DNWeakself
    self.paramSelectControl.selectedBlock = ^(NSString *value, DNReleaseRecruitParam param){
        UIView *subView = [weakSelf.scrollView viewWithTag:DNReleaseRecruitValueTag + param];
        if ([subView isKindOfClass:[UILabel class]]) {
            ((UILabel *)subView).text = value;
            [weakSelf.cellValueArr replaceObjectAtIndex:param withObject:value];
        }
    };
}

- (void)didSelectedArar{
    DNWeakself
    self.areaSelectControl.selectedBlock = ^(NSString *value, NSString *id_Value){
        if (value.length > 0) {
            UIView *subView = [weakSelf.scrollView viewWithTag:DNReleaseRecruitValueTag + DNReleaseRecruitParam_Area];
            if ([subView isKindOfClass:[UILabel class]]) {
                ((UILabel *)subView).text = value;
                [weakSelf.cellValueArr replaceObjectAtIndex:DNReleaseRecruitParam_Area withObject:value];
            }
            [weakSelf.cellValueArr replaceObjectAtIndex:2 withObject:value];
        }
    };
}



#pragma mark - private
- (void)dismissKeyboard:(UIButton *)sender{
    if ([self.descriptionTextView isFirstResponder]) {
        [self.descriptionTextView resignFirstResponder];
    }else if ([self.contactTextView isFirstResponder]){
        [self.contactTextView resignFirstResponder];
    }else{
        [self.numberTf resignFirstResponder];
    }
}

- (BOOL)verifyParam{
    BOOL verify = YES;
    if ([self.cellValueArr containsObject:@"必填"]) {
        verify = NO;
    }else if (self.descriptionTextView.text.length < 1 || self.contactTextView.text.length < 1){
        verify = NO;
    }else if (self.releaseType == DNRecruitDetailType_RECRUIT && self.numberTf.text.length < 1){
        verify = NO;
    }
    return verify;
}


#pragma mark - UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    NSInteger scrollY = 0;
    if ([textView isEqual:self.descriptionTextView]) {
        scrollY = 80;
    }else{
        scrollY = 180;
    }
    scrollY = ScreenHeight <= 568 ? scrollY + scrollY * 0.5 : scrollY;
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.top = -scrollY;
    }];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.25 animations:^{
        self.scrollView.top = 0;
    }];
    return YES;
}

#pragma mark - UITextFiledDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([[NSString stringWithFormat:@"%@%@",textField.text,string] integerValue] > 98) {
        [SVProgressHUD showErrorWithStatus:@"招聘人数应该在100人以下"];
        return NO;
    }else if ([[NSString stringWithFormat:@"%@%@",textField.text,string] integerValue] <=0){
        [SVProgressHUD showErrorWithStatus:@"请填写正确的招聘人数"];
        return NO;
    }
    return YES;
}

#pragma mark - UIScrollViewDelegate
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [scrollView resignFirstResponder];
}


#pragma mark - getter
- (NSMutableArray *)cellKeyArr{
    if (!_cellKeyArr) {
        if (_releaseType == DNRecruitDetailType_JOB) {
            _cellKeyArr = [@[@"应聘岗位",@"期望薪资",@"试用",@"工作地区",@"工作经验",@"学历",@"个人描述",@"联系方式"] mutableCopy];
        }else{
            _cellKeyArr = [@[@"招聘职位",@"薪资",@"试用",@"地区",@"招聘人数",@"学历",@"个人描述",@"联系方式"] mutableCopy];
        }
    }
    return _cellKeyArr;
}

- (NSMutableArray *)cellValueArr{
    if (!_cellValueArr) {
        _cellValueArr = [@[@"必填",@"必填",@"",@"必填",@"必填",@"必填"] mutableCopy];
        if (_releaseType == DNRecruitDetailType_RECRUIT) {
            [_cellValueArr replaceObjectAtIndex:4 withObject:@""];
        }
    }
    return _cellValueArr;
}

- (DNSelectControl *)areaSelectControl{
    if (!_areaSelectControl) {
        _areaSelectControl = [[DNSelectControl alloc] init];
    }
    return _areaSelectControl;
}

- (DNSingleSelectControl *)paramSelectControl{
    if (!_paramSelectControl) {
        _paramSelectControl = [[DNSingleSelectControl alloc] init];
    }
    return _paramSelectControl;
}


@end
