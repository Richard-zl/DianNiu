//
//  DNApplyRecordCell.m
//  Dianniu
//
//  Created by RIMI on 2017/2/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNApplyRecordCell.h"

@interface DNApplyRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *postNameLb;//岗位名称

@property (weak, nonatomic) IBOutlet UILabel *areaKeyLb;//地区key

@property (weak, nonatomic) IBOutlet UILabel *araValueLb;//地区value

@property (weak, nonatomic) IBOutlet UILabel *salaryKeyLb;//工作经验／薪资 key

@property (weak, nonatomic) IBOutlet UILabel *salaryValueLb;//工作经验/薪资 value

@property (weak, nonatomic) IBOutlet UILabel *tryoutLb;//是否可试用

@property (weak, nonatomic) IBOutlet UILabel *timeLb;

@end

@implementation DNApplyRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setType:(DNRecruitDetailType)type{
    _type = type;
    [self configurCellWithType];
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    [self updateSubViews];
}

- (void)configurCellWithType{
    if (self.type == DNRecruitDetailType_JOB) {
        //申请的求职
        self.salaryKeyLb.text = @"工作经验：";
        self.salaryValueLb.text = [self.dataSource DNObjectForKey:@"experience"];
    }else{
        //申请的招聘
        self.salaryKeyLb.text = @"薪资：";
        self.salaryValueLb.text = [self.dataSource DNObjectForKey:@"salary"];
    }
}

- (void)updateSubViews{
    self.postNameLb.text = [self.dataSource DNObjectForKey:@"post"];
    self.araValueLb.text = [self.dataSource DNObjectForKey:@"address"];
    self.tryoutLb.text = [self.dataSource DNObjectForKey:@"tryoutDesc"];
    NSString *timeStr = [self.dataSource DNObjectForKey:@"createDate"];
    if (timeStr.length > 5) {
        timeStr = [[timeStr componentsSeparatedByString:@" "] firstObject];
    }else{
        timeStr = @"未知";
    }
    self.timeLb.text = timeStr;
}

@end
