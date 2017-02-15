//
//  DNUserCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/19.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNUserCell.h"
#import <UIImageView+WebCache.h>
#import "DNAliSDKManager.h"
@interface DNUserCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLb;
@property (weak, nonatomic) IBOutlet UILabel *tagLb;

@end
@implementation DNUserCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUserDic:(NSDictionary *)userDic{
    _userDic = userDic;
    [self updateSubViews];
}

- (void)updateSubViews{
    NSString *urlPath = [DNAliSDKManager aliMediaSDKImagePath:[_userDic DNObjectForKey:@"headPic"]];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:urlPath]];
    self.nameLb.text = [_userDic DNObjectForKey:@"realName"];
    self.tagLb.text  = [_userDic DNObjectForKey:@"label"];
}

@end
