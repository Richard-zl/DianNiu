//
//  DNSingleSelectControl.m
//  Dianniu
//
//  Created by RIMI on 2017/2/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNSingleSelectControl.h"
@interface DNSingleSelectControl ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, assign)DNReleaseRecruitParam paramType;
@end
@implementation DNSingleSelectControl

- (instancetype)init{
    if (self = [super init]) {
        [self creatAccessoryView];
        [self creatInputView];
    }
    return self;
}

#pragma mark - publc
- (void)showData:(NSArray<NSString *> *)data andParam:(DNReleaseRecruitParam)param{
    self.paramType = param;
    self.dataSource = data;
    self.value = [data firstObject];
    [((UIPickerView *)self.inputView) selectRow:0 inComponent:0 animated:NO];
    [((UIPickerView *)self.inputView) reloadAllComponents];
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (void)dismiss{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

#pragma mrak - Event
- (void)buttonAction:(UIBarButtonItem *)item{
    NSString *value = nil;
    if ([item.title isEqualToString:@"确定"]) {
        value = self.value;
        if (self.selectedBlock) {
            self.selectedBlock(value,self.paramType);
        }
    }
    [self dismiss];
}

#pragma mark private
- (void)creatAccessoryView{
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeToFit];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    UIBarButtonItem *nilItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *domeItem  = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(buttonAction:)];
    toolBar.items = @[cancelItem,nilItem,domeItem];
    self.inputAccessoryView = toolBar;
}

- (void)creatInputView{
    UIPickerView *pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    self.inputView = pickerView;
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.dataSource.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (row < self.dataSource.count) {
        return self.dataSource[row];
    }
    return nil;
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (row < self.dataSource.count) {
        self.value = self.dataSource[row];
    }
}



@end
