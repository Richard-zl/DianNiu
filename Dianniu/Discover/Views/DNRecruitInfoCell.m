//
//  DNRecruitInfoCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitInfoCell.h"
#import "DNWebViewController.h"

@interface DNRecruitInfoCell ()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *salaryKeyLb;
@property (weak, nonatomic) IBOutlet UILabel *salaryValueLb;
@property (weak, nonatomic) IBOutlet UILabel *tryoutLb;//试用
@property (weak, nonatomic) IBOutlet UILabel *addressLb;
@property (weak, nonatomic) IBOutlet UILabel *recruitNumberKeyLb; //求职：工作经验   招聘：招聘人数
@property (weak, nonatomic) IBOutlet UILabel *recruitNumberValueLb;
@property (weak, nonatomic) IBOutlet UILabel *educationLb;//学历
@property (weak, nonatomic) IBOutlet UIButton *tryoutButton;


//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewTopCons;

@end
@implementation DNRecruitInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    [self updateSubViews];
}

- (void)updateSubViews{
    if (self.type == DNRecruitDetailType_RECRUIT) {
        self.salaryKeyLb.text = @"薪资：";
        self.recruitNumberKeyLb.text = @"招聘人数：";
        self.recruitNumberValueLb.text = [self.dataSource DNObjectForKey:@"recruitCount"];
        if (!self.lineView.isHidden) {
            self.lineView.hidden = YES;
            self.lineViewTopCons.constant = 0;
        }
    }else{
        self.recruitNumberValueLb.text = [self.dataSource DNObjectForKey:@"experience"];
    }
    self.salaryValueLb.text = [self.dataSource DNObjectForKey:@"salary"];
    self.tryoutLb.text = [self.dataSource DNObjectForKey:@"tryoutDesc"];
    self.addressLb.text = [self.dataSource DNObjectForKey:@"address"];
    self.educationLb.text = [self.dataSource DNObjectForKey:@"education"];
}

#pragma mark - Ecent
- (IBAction)tryoutButtonAction:(UIButton *)sender {
    NSString *path = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"webResource/tryoutRule.html"];
    DNWebViewController *controller = [[DNWebViewController alloc] initWithFilePath:path script:nil];
    controller.title = @"试用规则";
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            [((UIViewController*)nextResponder).navigationController pushViewController:controller animated:YES];
        }
    }
}


@end
