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
    cell.dianniuQ_AViewModel = viewModel;
    return cell;
}




@end
