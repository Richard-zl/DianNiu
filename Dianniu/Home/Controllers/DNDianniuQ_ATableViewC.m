//
//  DNDianniuQ_ATableViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNDianniuQ_ATableViewC.h"
#import "DNDianniuQ_ACell.h"
#import "DNQ_ADetailViewC.h"
#import "DNUserDetailC.h"
#import "DNInformationViewC.h"

@interface DNDianniuQ_ATableViewC ()
@end

@implementation DNDianniuQ_ATableViewC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DNDianniuQ_ACell *cell = [tableView dequeueReusableCellWithIdentifier:@"dianniuQ_ACell"];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([DNDianniuQ_ACell class]) owner:nil options:nil] firstObject];
    }
    DNDianniuQ_AViewModel *viewModel;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    NSArray *content    = self.dianniuQ_ADataSource[@"content"];
    if (hotContent.count > 0) {
        viewModel = indexPath.section == 0 ? hotContent[indexPath.row] : content[indexPath.row];
    }else{
        viewModel = content[indexPath.row];
    }
    cell.didClickDetailView = [self pushUserDetailViewBlock];
    cell.dianniuQ_AViewModel = viewModel;
    return cell;
}

- (void (^)(DNDianniuQ_AViewModel *viewModel))pushUserDetailViewBlock{
    return ^(DNDianniuQ_AViewModel *viewModel){
        if ([viewModel.q_aModel.accountId integerValue] == [[DNUser sheared].userId integerValue]) {
            //我的资料
            DNInformationViewC *infoC = [[DNInformationViewC alloc] init];
            [self.navigationController pushViewController:infoC animated:YES];
        }else{
            DNUserDetailC *detailC = [[DNUserDetailC alloc] initWithNibName:@"DNUserDetailC" bundle:nil];
            detailC.accountId = viewModel.q_aModel.accountId;
            [self.navigationController pushViewController:detailC animated:YES];
        }
    };
}


@end
