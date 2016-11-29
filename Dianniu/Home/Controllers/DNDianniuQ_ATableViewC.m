//
//  DNDianniuQ_ATableViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/11/29.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNDianniuQ_ATableViewC.h"

@interface DNDianniuQ_ATableViewC ()
@property (nonatomic, strong)NSMutableDictionary *dianniuQ_ADataSource;
@end

@implementation DNDianniuQ_ATableViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];
}

- (void)tableViewDidReload:(NSMutableDictionary *)dataDict{
    //字典结构:
    //@{@"hotContent":@[viewModel,viewModel]
    //  @"content    :@[viewModel,viewModel]"}
    self.dianniuQ_ADataSource = dataDict;
    [self.tableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sections = 1;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    if (hotContent.count > 0) {
        sections = 2;
    }
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    NSArray *content    = self.dianniuQ_ADataSource[@"content"];
    if (hotContent.count > 0) {
        rows = section == 0 ? hotContent.count : content.count;
    }else{
        rows = content.count;
    }
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abcCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abcCell"];
        cell.height = 60;
    }
    DNDianniuQ_AViewModel *viewModel;
    NSArray *hotContent = self.dianniuQ_ADataSource[@"hotContent"];
    NSArray *content    = self.dianniuQ_ADataSource[@"content"];
    if (hotContent.count > 0) {
        viewModel = indexPath.section == 0 ? hotContent[indexPath.row] : content[indexPath.row];
    }else{
        viewModel = content[indexPath.row];
    }
    cell.textLabel.text = viewModel.text;
    
    return cell;
}

#pragma mark - getter and setter
- (NSMutableDictionary *)dianniuQ_ADataSource{
    if (!_dianniuQ_ADataSource) {
        _dianniuQ_ADataSource = [NSMutableDictionary dictionary];
    }
    return _dianniuQ_ADataSource;
}




@end
