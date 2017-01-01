//
//  DNAskquestionViewC.m
//  Dianniu
//
//  Created by RIMI on 2016/12/27.
//  Copyright © 2016年 Dianniu. All rights reserved.
//

#import "DNAskquestionViewC.h"
#import "DNAliSDKManager.h"
#import <UIImageView+WebCache.h>
#import "DNReleaseQuestRequest.h"

@interface DNAskquestionViewC ()<UICollectionViewDelegate,UICollectionViewDataSource,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *wordsLb;
@property (weak, nonatomic) IBOutlet UILabel *placeholderLb;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong)NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeightCons;

@end

@implementation DNAskquestionViewC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configurSubviews];
}

#pragma mark - UI private
- (void)configurSubviews{
    if (self.type == DNHomeListType_questions) {
        //提问
        self.title = @"提问";
        self.placeholderLb.text = @"上帝给你关上一扇门，总会为你在墙上留下很多开锁的电话号码";
    }else{
        //匿名
        self.title = @"匿名";
        self.placeholderLb.text = @"不是我执着，而是你值得！";
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self configurRightButton];
    [self configurCollectionView];
}

- (void)configurRightButton{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(commitButtonAction)];
    rightItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightItem;
    self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)configurCollectionView{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"DNAddImgCell"];
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    CGFloat itemWH = (self.collectionView.width - (5 * 2))/6;
    layout.itemSize = CGSizeMake(itemWH, itemWH);
    self.collectionViewHeightCons.constant = itemWH + 10;
}

#pragma mark - private func
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

#pragma mark - Event
- (void)commitButtonAction{
    DNReleaseQuestRequest *request = [DNReleaseQuestRequest new];
    request.content = self.textView.text;
    request.type = self.type;
    request.accountId = [DNUser sheared].userId;
    if (self.dataSource.count > 0) {
        for (NSDictionary *dict in self.dataSource) {
            if (request.questImgs.length < 1) {
                request.questImgs = dict[@"fileName"];
            }else{
                request.questImgs = [NSString stringWithFormat:@"%@,%@",request.questImgs,dict[@"fileName"]];
            }
        }
    }else{
        request.questImgs= @"";
    }
    [request httpRequest:15 success:^(NSURLSessionDataTask *sessionTask, id respondObj) {
        //成功
        [SVProgressHUD showSuccessWithStatus:@"发布成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failed:nil];
    
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.placeholderLb.hidden = YES;
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }else{
        self.placeholderLb.hidden = NO;
        self.navigationItem.rightBarButtonItem.enabled = NO;

    }
    self.wordsLb.text = [NSString stringWithFormat:@"%ld/150",textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length + text.length >= 151) {
        return NO;
    }
    return YES;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.dataSource.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DNAddImgCell" forIndexPath:indexPath];
    UIImageView *imageView = [cell viewWithTag:10];
    if (!imageView) {
        UIImageView *tempImgV = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        tempImgV.contentMode = UIViewContentModeScaleToFill;
        tempImgV.userInteractionEnabled = YES;
        tempImgV.image = [UIImage imageNamed:@"add_pic_icon"];
        [cell.contentView addSubview:tempImgV];
        imageView = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imageView.tag = 10;
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.userInteractionEnabled = YES;
        [cell.contentView addSubview:imageView];
    }
    cell.backgroundColor = [UIColor blackColor];
    if (self.dataSource.count == indexPath.row) {
        imageView.hidden = YES;
    }else{
        imageView.hidden = NO;
        imageView.image = self.dataSource[indexPath.row][@"image"];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataSource.count == indexPath.row) {
        //增加照片
        if (self.dataSource.count == 6){
            [SVProgressHUD showErrorWithStatus:@"最多只能添加六张图片"];
            return;
        }
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册选择", nil];
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
    }else{
        //浏览照片
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
    [DNAliSDKManager uploadWithData:imageData progress:nil success:^(NSString *url,NSString *fileName) {
        [SVProgressHUD dismiss];
        [self.dataSource addObject:@{@"url":url,@"fileName":fileName,@"image":image}];
        [self.collectionView reloadData];
    } failed:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"上传失败:(%@)",error.description]];
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.textView resignFirstResponder];
}
#pragma mark - getter
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
