//
//  DNLabelSetViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/6.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNLabelSetViewC.h"
#import "DNProfileModifyRequest.h"
#import "DNLabelSetCell.h"
#import "DNSelectControl.h"
#import "DNMoreLabelViewC.h"

#define DNLabelSetViewCellEdge 10.0
#define DNLabelSetViewCellIdentifier @"DNLabelSetViewCellIdentifier"
@interface DNLabelSetViewC ()<UICollectionViewDelegate,UICollectionViewDataSource,DNMoerLabelDelegate>
@property (weak, nonatomic) IBOutlet UITextField *dataTf;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) DNSelectControl *selectControl;
@property (nonatomic, nonnull, strong) NSMutableArray *dataSource;
@property (nonatomic, copy) NSString *area_id;

@property (weak, nonatomic) IBOutlet UILabel *areaLb;
@property (nonatomic, strong) UIButton *firstSelectedBut;
@property (nonatomic, strong) UIButton *secondSelectedBut;
@property (nonatomic, strong) UIButton *thirdSelectedBut;
@end

@implementation DNLabelSetViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configSubViews];
}

#pragma mark - UI Metheod
- (void)configSubViews{
    [self.view addSubview:self.selectControl];
    [self configurRightButton];
    [self configurCollectionView];
}

- (void)configurRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确认" style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonAction:)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)configurCollectionView{
    [self.collectionView registerNib:[UINib nibWithNibName:@"DNLabelSetCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:DNLabelSetViewCellIdentifier];
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNLabelSetViewCellHederViewId"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout*)self.collectionView.collectionViewLayout;
    layout.itemSize = CGSizeMake((ScreenWidth - DNLabelSetViewCellEdge * 4)/3, 40);
    layout.minimumLineSpacing = 8.0;
    layout.minimumInteritemSpacing = DNLabelSetViewCellEdge;
    layout.headerReferenceSize = CGSizeMake(ScreenWidth, 45);
}

#pragma mark - private func
- (BOOL)verifyParams{
    BOOL isVerfy = YES;
    if (!self.firstSelectedBut) {
        isVerfy = NO;
        [SVProgressHUD showErrorWithStatus:@"请选择职位"];
    }else if (!self.secondSelectedBut){
        isVerfy = NO;
        [SVProgressHUD showErrorWithStatus:@"请选择行业"];
    }else if (!self.thirdSelectedBut){
        isVerfy = NO;
        [SVProgressHUD showErrorWithStatus:@"请选择平台"];
    }else if (self.areaLb.text.length < 1){
        isVerfy = NO;
        [SVProgressHUD showErrorWithStatus:@"请选择地区"];
    }
    
    return isVerfy;
}

- (void)updateDataSource{
    NSString *firstTitle = @"", *secondTitle = @"", *thirdTitle = @"", *fourthTitle = @"";
    if (self.firstSelectedBut) {
        firstTitle = [NSString stringWithFormat:@"%@/",[self.firstSelectedBut titleForState:UIControlStateNormal]];
    }
    if (self.secondSelectedBut) {
        secondTitle = [NSString stringWithFormat:@"%@/",[self.secondSelectedBut titleForState:UIControlStateNormal]];
    }
    if (self.thirdSelectedBut) {
        thirdTitle = [NSString stringWithFormat:@"%@|",[self.thirdSelectedBut titleForState:UIControlStateNormal]];
    }
    if (self.areaLb.text.length > 0) {
        fourthTitle = self.areaLb.text;
    }
    self.dataTf.text = [NSString stringWithFormat:@"%@%@%@%@",firstTitle,secondTitle,thirdTitle,fourthTitle];
}

#pragma mark - Event
- (void)commitButtonAction:(UIBarButtonItem *)item{
    if (![self verifyParams]) {
        return;
    }
    NSString *paramStr = [[self.dataTf.text componentsSeparatedByString:@"|"] firstObject];
    paramStr = [NSString stringWithFormat:@"%@|%@",paramStr,self.area_id];
    DNProfileModifyRequest *request = [[DNProfileModifyRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.type      = DNProfileModifyType_Label;
    request.value     = paramStr;
    [SVProgressHUD showWithStatus:@"正在设置..."];
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        [SVProgressHUD dismiss];
        [DNUser sheared].tag = self.dataTf.text;
        [[DNUser sheared] dump];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
        
    }];
}
- (IBAction)clickonAreaBut:(UITapGestureRecognizer *)sender {
    [self.selectControl show];
}

- (void(^)(NSString *value,NSString *id_value))didSelectedArea{
    DNWeakself;
    return [^(NSString *value,NSString *id_value){
        if (value && value.length > 0) {
            weakSelf.areaLb.text = value;
            weakSelf.area_id = id_value;
            [weakSelf updateDataSource];
        }
    } copy];
}
//更多标签选择回调
- (void)didSelectedLabel:(UIButton *)target{
    if (target) {
        NSInteger row = [self.dataSource[1] count] - 1;
        DNLabelSetCell* cell =(DNLabelSetCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
        cell.titleBut.selected = YES;
        self.secondSelectedBut = target;
        [self updateDataSource];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  [self.dataSource[section] count];
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,DNLabelSetViewCellEdge, 0, DNLabelSetViewCellEdge);//分别为上、左、下、右
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView* reusableView;
    if (kind==UICollectionElementKindSectionHeader) {
        reusableView=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"DNLabelSetViewCellHederViewId" forIndexPath:indexPath];
        UILabel *titleLb = [reusableView viewWithTag:101];
        if (!titleLb) {
            titleLb = [[UILabel alloc] initWithFrame:reusableView.bounds];
            titleLb.left = DNLabelSetViewCellEdge;
            titleLb.textColor = [UIColor darkGrayColor];
            titleLb.font = [UIFont systemFontOfSize:18];
            [reusableView addSubview:titleLb];
        }
        titleLb.text = @[@"职位",@"行业",@"平台"][indexPath.section];
    }
    reusableView.backgroundColor= RGBColor(241, 241, 241);
    return reusableView;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DNLabelSetCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:DNLabelSetViewCellIdentifier forIndexPath:indexPath];
    [cell.titleBut setTitle:self.dataSource[indexPath.section][indexPath.row] forState:UIControlStateNormal];
    cell.indexPath = indexPath;
    DNWeakself
    cell.didSelected = ^(BOOL selected,NSIndexPath *path,UIButton *target){
        if (path.section == 1 && path.row == [weakSelf.dataSource[path.section] count] -1) {
            //选择的更多
            target.selected = NO;
            weakSelf.secondSelectedBut = nil;
            [weakSelf updateDataSource];
            DNMoreLabelViewC *viewC = [[DNMoreLabelViewC alloc] init];
            viewC.delegate = weakSelf;
            [weakSelf.navigationController pushViewController:viewC animated:YES];
            return ;
        }
        if (selected) {
            if (path.section == 0) {
                weakSelf.firstSelectedBut.selected = NO;
                weakSelf.firstSelectedBut = target;
            }else if (path.section == 1){
                //每次点击了行业这一栏的标签都要检查 其他>>标签有没有被选中
                NSInteger row = [weakSelf.dataSource[1] count] - 1;
                DNLabelSetCell* cell =(DNLabelSetCell*) [weakSelf.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:1]];
                if (cell.titleBut.isSelected) {
                    cell.titleBut.selected = NO;
                }
                weakSelf.secondSelectedBut.selected = NO;
                weakSelf.secondSelectedBut = target;
            }else if (path.section == 2){
                weakSelf.thirdSelectedBut.selected = NO;
                weakSelf.thirdSelectedBut = target;
            }
        }else{
            if (path.section == 0) {
                weakSelf.firstSelectedBut = nil;
            }else if (path.section == 1){
                weakSelf.secondSelectedBut = nil;
            }else if (path.section == 2){
                weakSelf.thirdSelectedBut = nil;
            }
        }

        [weakSelf updateDataSource];
    };
    return cell;
}

#pragma mark - getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:@[@"店长",@"客服",@"运营",@"仓管",@"UI设计",@"其他"]];
        [_dataSource addObject:@[@"服装",@"鞋靴箱包",@"家电数码",@"珠宝首饰",@"汽车用品",@"更多>>"]];
        [_dataSource addObject:@[@"淘宝",@"京东",@"蘑菇街",@"美丽说",@"其他"]];
    }
    return _dataSource;
}

- (DNSelectControl *)selectControl{
    if (!_selectControl) {
        _selectControl = [[DNSelectControl alloc] init];
        _selectControl.selectedBlock = [self didSelectedArea];
    }
    return _selectControl;
}

@end
