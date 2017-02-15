//
//  DNRecruitPostCell.m
//  Dianniu
//
//  Created by RIMI on 2017/1/24.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNRecruitPostCell.h"
#import "DNShareSDKManager.h"
@interface DNRecruitPostCell ()
@property (weak, nonatomic) IBOutlet UILabel *postNamelb;
@property (weak, nonatomic) IBOutlet UIButton *sharedBut;
@end
@implementation DNRecruitPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.sharedBut.layer.cornerRadius = self.sharedBut.height/2;
    self.sharedBut.backgroundColor = [UIColor whiteColor];
    self.sharedBut.layer.borderColor = DNThemeColor.CGColor;
    self.sharedBut.layer.borderWidth = 1.5;
}

- (void)setDataSource:(NSMutableDictionary *)dataSource{
    _dataSource = dataSource;
    NSString *postName = [self.dataSource DNObjectForKey:@"post"];
    if (postName) {
        self.postNamelb.text = postName;
    }
}

- (IBAction)sharedButtonAction:(UIButton *)sender {
    DNShareType sharetype;
    NSString *subContent;
    if (self.type == DNRecruitDetailType_RECRUIT) {
        sharetype = DNShareType_Recruit;
        subContent = [NSString stringWithFormat:@"薪资：%@",[self.dataSource DNObjectForKey:@"salary"]];
    }else{
        sharetype = DNShareType_Job;
        subContent = [NSString stringWithFormat:@"工作经验：%@",[self.dataSource DNObjectForKey:@"experience"]];
    }
    NSString *content = [NSString stringWithFormat:@"职位：%@\n%@",self.postNamelb.text,subContent];
    [[DNShareSDKManager shared] shareContentWithType:sharetype content:content shareId:[self.dataSource DNObjectForKey:@"id"] imagePath:nil success:^(NSInteger platform) {
        
    }];
}


@end
