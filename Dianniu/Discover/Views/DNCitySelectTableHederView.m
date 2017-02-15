//
//  DNCitySelectTableHederView.m
//  Dianniu
//
//  Created by RIMI on 2017/1/22.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNCitySelectTableHederView.h"
#import "DNPhone.h"

@interface DNCitySelectTableHederView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLb;
@property (weak, nonatomic) IBOutlet UIButton *cityBut;

@end

@implementation DNCitySelectTableHederView
- (void)awakeFromNib{
    [super awakeFromNib];
    if (![DNPhone shared].city ||
        [DNPhone shared].city.length < 1 ||
        [[DNPhone shared].city isEqualToString:@"未知"]) {
        //定位失败 需要重新定位
        self.titleLb.text = @"定位失败";
        [self.cityBut setTitle:@"重新定位" forState:UIControlStateNormal];
    }else{
        [self.cityBut setTitle:[DNPhone shared].city forState:UIControlStateNormal];
    }
    self.cityBut.layer.cornerRadius = self.cityBut.height/2;
}

- (IBAction)cityButtonAction:(id)sender {
    if (![DNPhone shared].city ||
        [DNPhone shared].city.length < 1 ||
        [[DNPhone shared].city isEqualToString:@"未知"]) {
        //重新定位
        [self.cityBut setTitle:@"正在定位" forState:UIControlStateNormal];
        [[DNPhone shared] refreshCurrentLocation];
        [[DNPhone shared] bk_addObserverForKeyPath:@"city" task:^(id target) {
            [self.cityBut setTitle:((DNPhone *)target).city forState:UIControlStateNormal];
            self.titleLb.text = @"当前定位城市";
        }];
    }else{
        //直接跳转
        [DNPhone shared].selectCity = [DNPhone shared].city;
        for (UIView* next = [self superview]; next; next = next.superview) {
            UIResponder* nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                [((UIViewController*)nextResponder).navigationController popViewControllerAnimated:YES];
                
            }
        }
    }
}

- (void)dealloc{
    [[DNPhone shared] bk_removeObserverForKeyPath:@"city" identifier:[[NSProcessInfo processInfo] globallyUniqueString]];
}

@end
