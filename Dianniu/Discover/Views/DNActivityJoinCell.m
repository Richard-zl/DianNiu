//
//  DNActivityJoinCell.m
//  Dianniu
//
//  Created by RIMI on 2017/2/13.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNActivityJoinCell.h"
#import <UIImageView+WebCache.h>

@interface DNActivityJoinCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;

@end

@implementation DNActivityJoinCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headerImageView.layer.cornerRadius = self.headerImageView.width/2;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setDataSource:(NSDictionary *)dataSource{
    _dataSource = dataSource;
    [self updateSubViews];
}

- (void)updateSubViews{
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[DNAliSDKManager aliMediaSDKImagePath:[self.dataSource DNObjectForKey:@"headPic"]]]];
    self.nameLb.text = [self.dataSource DNObjectForKey:@"realName"];
    self.tagLb.text  = [self.dataSource DNObjectForKey:@"label"];
}

@end
