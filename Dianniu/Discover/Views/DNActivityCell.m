//
//  DNActivityCell.m
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityCell.h"
#import <UIImageView+WebCache.h>
#import "DNAliSDKManager.h"

@interface DNActivityCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;
@property (weak, nonatomic) IBOutlet UILabel *activityNameLb;
@property (weak, nonatomic) IBOutlet UILabel *numberLb;
@property (weak, nonatomic) IBOutlet UILabel *timeLb;
@property (weak, nonatomic) IBOutlet UILabel *amountLb;
@property (weak, nonatomic) IBOutlet UILabel *loactionLb;

@end

@implementation DNActivityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    [self updateSubViews];
}

- (void)updateSubViews{
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:[DNAliSDKManager aliMediaSDKImagePath:[self.dataSource DNObjectForKey:@"headPic"]]]];
    self.nameLb.text = [self.dataSource DNObjectForKey:@"realName"];
    self.tagLb.text  = [self.dataSource DNObjectForKey:@"label"];
    self.activityNameLb.text = [self.dataSource DNObjectForKey:@"subject"];
    self.numberLb.text = [self.dataSource DNObjectForKey:@"persionSection"];
    NSString *constType = [self.dataSource DNObjectForKey:@"costTypeDesc"];
    if (![constType isEqualToString:@"免费"]) {
       constType = [constType stringByAppendingString:[self.dataSource DNObjectForKey:@"costTypeContent"]];
    }
    self.amountLb.text = constType;
    self.timeLb.text = [self.dataSource DNObjectForKey:@"startDate"];
    self.loactionLb.text = [self.dataSource DNObjectForKey:@"address"];
}

@end
