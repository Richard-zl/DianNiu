//
//  DNRecruitDesciptionCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/25.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitDesciptionCell.h"
@interface DNRecruitDesciptionCell ()
@property (weak, nonatomic) IBOutlet UILabel *descriptionKeyLb;
@property (weak, nonatomic) IBOutlet UILabel *descriptionValueLb;
@property (weak, nonatomic) IBOutlet UILabel *contactLb;

//约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descriptionLbWidthCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contactLbWidthCons;

@end
@implementation DNRecruitDesciptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.descriptionLbWidthCons.constant = ScreenWidth - 16;
    self.contactLbWidthCons.constant = ScreenWidth - 16;
}

- (void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    [self updateSubViews];
}

- (void)updateSubViews{
    if (self.type == DNRecruitDetailType_RECRUIT) {
        self.descriptionKeyLb.text = @"职位描述";
    }
    self.descriptionValueLb.text = [self.dataSource DNObjectForKey:@"describe"];
    self.contactLb.text  = [self.dataSource DNObjectForKey:@"contactWay"];
    CGFloat height = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingExpandedSize].height + 1;
    [self.dataSource setObject:@(height) forKey:@"lastCellHeight"];
}

@end
