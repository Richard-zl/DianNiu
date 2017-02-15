//
//  DNCitySelectViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/22.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNCitySelectViewC.h"
#import "DNCitysViewModel.h"
#import "DNPhone.h"
#import "DNCitySelectTableHederView.h"

@interface DNCitySelectViewC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DNCitysViewModel *citysViewModel;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSArray<DNCityModel *> *searchArr;
@end

@implementation DNCitySelectViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择城市";
    self.isSearch = NO;
    [self configurSubViews];
}

- (void)configurSubViews{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = self.tableView.backgroundColor;
    [self.view addSubview:self.searchBar];
    [self.view addSubview:self.tableView];
    [self configurTableHederView];
    [self configurTableViewSectionIndex];
}

- (void)configurTableHederView{
    DNCitySelectTableHederView *hederView = [[[NSBundle mainBundle] loadNibNamed:@"DNCitySelectTableHederView" owner:nil options:nil] firstObject];
    self.tableView.tableHeaderView = hederView;
}

- (void)configurTableViewSectionIndex{
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 24;
}


#pragma mark - private func


#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (searchBar.text.length > 0) {
        self.isSearch = YES;
        [self.citysViewModel searchCityWithString:searchBar.text didSearch:^(NSArray<DNCityModel *> *citys) {
            self.searchArr = citys;
            [self.tableView reloadData];
        }];
    }else{
        self.isSearch = NO;
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return 1;
    }else{
        return [self.citysViewModel sections];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isSearch) {
        return self.searchArr.count;
    }else{
        return [self.citysViewModel numberOfRowsInSection:section];
    }
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.isSearch) {
        return @[@""];
    }else{
        return [self.citysViewModel allinitials];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *sectionHederView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
    sectionHederView.backgroundColor = [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, sectionHederView.frame.size.width, 25)];
    label.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:14];
    label.textColor = [UIColor lightGrayColor];
    label.text = [self.citysViewModel initialStringWithSection:section];
    [sectionHederView addSubview:label];
    if (self.isSearch) {
        return nil;
    }else{
        return sectionHederView;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNCitySelctCell" forIndexPath:indexPath];
    DNCityModel *city;
    if (self.isSearch) {
        city = self.searchArr[indexPath.row];
    }else{
        city = [self.citysViewModel cityModelWithSection:indexPath.section Row:indexPath.row];
    }
    cell.textLabel.text = city.name;
    cell.textLabel.textColor = RGBColor(33, 33, 33);
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DNCityModel *city;
    if (self.isSearch) {
        city = self.searchArr[indexPath.row];
    }else{
        city = [self.citysViewModel cityModelWithSection:indexPath.section Row:indexPath.row];
    }
    [DNPhone shared].selectCity = city.name;
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    CGFloat viewWH = 100.0;
    UIView *animatorView = [[UIView alloc] initWithFrame:CGRectMake((ScreenWidth-viewWH)/2, (ScreenWidth - viewWH)/2, viewWH, viewWH)];
    animatorView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    animatorView.layer.cornerRadius = 4.0;
    animatorView.alpha = 0.1;
    UILabel *label = [[UILabel alloc] initWithFrame:animatorView.bounds];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:35];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [animatorView addSubview:label];
    [self.view addSubview:animatorView];
    
    [UIView animateWithDuration:0.8 animations:^{
        animatorView.alpha = 1;
    } completion:^(BOOL finished) {
        [animatorView removeFromSuperview];
    }];
    
    return index;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
    }
}

#pragma mark - getter
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
        _searchBar.barTintColor = [UIColor whiteColor];
        _searchBar.delegate = self;
        _searchBar.placeholder = @"搜索城市";
    }
    return _searchBar;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, ScreenWidth, ScreenHeight - self.searchBar.bottom - self.navigationController.navigationBar.bottom)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = RGBColor(241, 241, 241);
        _tableView.tableFooterView = [UIView new];
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"DNCitySelctCell"];
    }
    return _tableView;
}

- (DNCitysViewModel *)citysViewModel{
    if (!_citysViewModel) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"DNCitys" ofType:@"plist"];
        DNWeakself
        [SVProgressHUD showWithStatus:@"正在加载..."];
        _citysViewModel = [[DNCitysViewModel alloc] initWithDataPath:path didLoadBlock:^{
            [SVProgressHUD dismiss];
            [weakSelf.tableView reloadData];
        }];
    }
    return _citysViewModel;
}

@end
