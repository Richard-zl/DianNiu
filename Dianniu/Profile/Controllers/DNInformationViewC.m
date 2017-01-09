//
//  DNInformationViewC.m
//  Dianniu
//
//  Created by RIMI on 2017/1/5.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNInformationViewC.h"
#import "DNUserDetailRequest.h"
#import "DNProfileModifyRequest.h"
#import "DNUserDetailModel.h"
#import <UIImageView+WebCache.h>
#import "DNNicknameModifyViewC.h"
#import "DNDescriptionModifyViewC.h"
#import "DNSexModifyViewC.h"
#import "DNLabelSetViewC.h"

@interface DNInformationViewC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic, strong)NSMutableArray *dataSource;
@end

@implementation DNInformationViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑资料";
    self.tableView.tableFooterView = [UIView new];
    [self updateDataSource];
    [self userDetailRequest];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self reload];
}

#pragma mark - private func
- (void)userDetailRequest{
    DNUserDetailRequest *request = [[DNUserDetailRequest alloc] init];
    request.accountId = [DNUser sheared].userId;
    request.friendAccountId = [DNUser sheared].userId;
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        DNUserDetailModel *model = [[DNUserDetailModel alloc] initWhitDictionary:respondObj];
        [DNUser sheared].tag = model.label;
        [DNUser sheared].headerImgURL = [NSURL URLWithString:model.headPic];
        [DNUser sheared].realName     = model.realName;
        [DNUser sheared].sex          = model.sex;
        [DNUser sheared].userDesription = model.describe;
        [[DNUser sheared] dump];
        [self reload];
    } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
    }];
}

- (void)reload{
    [self updateDataSource];
    [self.tableView reloadData];
}

- (void)updateDataSource{
    self.dataSource[0][0] = @{@"title":@" 头像",@"value":[DNUser sheared].headerImgURL};
    self.dataSource[1][0] = @{@"title":@"昵称",@"value":[DNUser sheared].realName};
    self.dataSource[1][1] = @{@"title":@"电钮号",@"value":[[DNUser sheared].userId description]};
    self.dataSource[1][2] = @{@"title":@"手机号",@"value":[[DNUser sheared].mobile description]};
    self.dataSource[1][3] = @{@"title":@"标签",@"value":[DNUser sheared].tag};
    self.dataSource[1][4] = @{@"title":@"性别",@"value":[DNUser sheared].sexString};
    self.dataSource[1][5] = @{@"title":@" 个性签名",@"value":[DNUser sheared].userDesription};
}

/// 打开相机
- (void)openCamera
{
    [self openImagePickerControllerWithType:UIImagePickerControllerSourceTypeCamera];
}
/// 打开相册
- (void)openAlbum
{
    [self openImagePickerControllerWithType:UIImagePickerControllerSourceTypePhotoLibrary];
}
/// 打开ImagePickerController的方法
- (void)openImagePickerControllerWithType:(UIImagePickerControllerSourceType)type
{
    // 设备不可用  直接返回
    if (![UIImagePickerController isSourceTypeAvailable:type]) return;
    
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.sourceType = type;
    imgPicker.delegate = self;
    [self.navigationController presentViewController:imgPicker animated:YES completion:nil];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [@[@(1),@(6)][section] integerValue];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 80.0;
    }
    return 45.0;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = UIColorFromRGB(0xefefef);
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DNInformationCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"DNInformationCell"];
    }
    
    NSString *title = self.dataSource[indexPath.section][indexPath.row][@"title"];
    id        value = self.dataSource[indexPath.section][indexPath.row][@"value"];
    if (indexPath.section == 1 && (indexPath.row == 1 || indexPath.row == 2) ) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.detailTextLabel.textColor = DNThemeColor;
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    NSMutableAttributedString *attributedStr;
    if (indexPath.section == 1 && indexPath.row < 5) {
        attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"* %@",title]];
        [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 1)];
    }else{
        attributedStr = [[NSMutableAttributedString alloc] initWithString:title];
    }
    cell.textLabel.attributedText = attributedStr;
    if (indexPath.section == 0) {
        //image
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 70 - 30, 5, 70, 70)];
        imageView.layer.cornerRadius = 70 /2.0;
        imageView.layer.masksToBounds = YES;
        [cell.contentView addSubview:imageView];
        [imageView sd_setImageWithURL:value placeholderImage:[UIImage imageNamed:@"default_head_icon"]];
    }else{
        cell.detailTextLabel.text = value;
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        //上传头像
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
        [sheet bk_setDidDismissBlock:^(UIActionSheet *actionSheet, NSInteger index) {
            if (index == 0) {
                //拍照
                [self openCamera];
            }else if (index == 1){
                //相册
                [self openAlbum];
            }
        }];
        [sheet showInView:self.view];
    }else {
        UIViewController *viewC;
        switch (indexPath.row) {
            case 0:
            //昵称
                viewC = [[DNNicknameModifyViewC alloc] initWithNibName:@"DNNicknameModifyViewC" bundle:[NSBundle mainBundle]];
            break;
            case 3:
            //标签
                viewC = [[DNLabelSetViewC alloc] initWithNibName:@"DNLabelSetViewC" bundle:[NSBundle mainBundle]];
            break;
            case 4:
            //性别
                viewC = [[DNSexModifyViewC alloc] initWithNibName:@"DNSexModifyViewC" bundle:[NSBundle mainBundle]];
            break;
            case 5:
            //个性签名
                viewC = [[DNDescriptionModifyViewC alloc] initWithNibName:@"DNDescriptionModifyViewC" bundle:[NSBundle mainBundle]];
            break;
        }
        viewC ? [self.navigationController pushViewController:viewC animated:YES] : nil;
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    [DNAliSDKManager uploadWithData:imageData progress:nil success:^(NSString *url,NSString *fileName) {
        [SVProgressHUD dismiss];
        DNProfileModifyRequest *request = [[DNProfileModifyRequest alloc] init];
        request.type = DNProfileModifyType_Header;
        request.value       = fileName;
        request.accountId   = [DNUser sheared].userId;
        [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
            [DNUser sheared].headerImgURL = [NSURL URLWithString:url];
            [[DNUser sheared] dump];
            [self reload];
        } failed:^(NSURLSessionDataTask *sessionTask, NSError *error) {
            [SVProgressHUD showErrorWithStatus:@"上传头像失败"];
        }];
       
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"上传失败:(%@)",error.description]];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
        [_dataSource addObject:[NSMutableArray array]];
        [_dataSource addObject:[NSMutableArray array]];
    }
    return _dataSource;
}

@end
