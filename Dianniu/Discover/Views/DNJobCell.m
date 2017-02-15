//
//  DNJobCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNJobCell.h"

@interface DNJobCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UIButton *salaryLb;
@property (weak, nonatomic) IBOutlet UIButton *addrissLb;
@property (weak, nonatomic) IBOutlet UIButton *probationLb;

@property (weak, nonatomic) IBOutlet UILabel *desriptionLb;

@end

@implementation DNJobCell

- (void)awakeFromNib {
    [super awakeFromNib];
    for (UIView *view in self.contentView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            view.layer.cornerRadius = 3.0;
            view.layer.masksToBounds = YES;
        }
    }
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    [self updateSubViews];
}

- (void)updateSubViews{
    [self changeLabelBackgroundColor];
    NSString *postName = [self.dataSource DNObjectForKey:@"post"];
    if (postName.length < 1) {
        postName = @"未知";
    }
    self.nameLb.text = postName;
    NSString *addressStr = [self.dataSource DNObjectForKey:@"address"];
    if (addressStr.length < 1) {
        addressStr = @"未知地点";
    }
    [self.addrissLb setTitle:addressStr forState:UIControlStateNormal];
    [self.salaryLb setTitle:[self.dataSource DNObjectForKey:@"salary"] forState:UIControlStateNormal];
    [self.probationLb setTitle:[self.dataSource DNObjectForKey:@"tryoutDesc"] forState:UIControlStateNormal];
    self.desriptionLb.text = [self.dataSource DNObjectForKey:@"describe"];
}

- (void)changeLabelBackgroundColor{
    UIColor *color;
    NSString *salaryStr = [self.dataSource DNObjectForKey:@"salary"];
    if ([salaryStr isEqualToString:@"面议"]) {
        self.salaryLb.backgroundColor = RGBColor(71, 202, 170);
        return;
    }
    NSString *tempStr =  [[salaryStr componentsSeparatedByString:@"/"] firstObject];
    NSInteger salary = [[[tempStr componentsSeparatedByString:@"-"] firstObject] integerValue];
    if (salary <= 4000) {
        //0-4000用蓝色
        color = RGBColor(139, 227, 240);
    }else if (salary <= 7000){
        //4001-7000用黄色
        color = RGBColor(248, 204, 3);
    }else if (salary > 7000){
        //7000以上用红色
        color = RGBColor(234, 99, 101);
    }
    self.salaryLb.backgroundColor = color;
}

@end
