//
//  DNSelectControl.m
//  Dianniu
//
//  Created by RIMI on 2017/1/9.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNSelectControl.h"

@interface DNSelectControl ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *id_value;
@end

@implementation DNSelectControl

- (instancetype)init{
    self = [super init];
    if (self) {
        self.dataSource = [self readLocalPlist];
        [self creatAccessoryView];
        [self creatInputView];
    }
    return self;
}


#pragma mark - public
- (void)show{
    self.value = @"";
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
    NSString *value = @"", *id_value;
    if ([item.title isEqualToString:@"确定"]) {
        value = self.value;
        id_value = self.id_value;
    }
    [self dismiss];
    if (self.selectedBlock) {
        self.selectedBlock(value,id_value);
    }
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

- (NSArray *)readLocalPlist{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DNArea" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:path];
}

#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return self.dataSource.count;
    }else{
        NSInteger section = [pickerView selectedRowInComponent:0];
        if (section >= 0 && section < self.dataSource.count) {
            return [self.dataSource[section][@"citys"] count];
        }else{
            return 0;
        }
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return self.dataSource[row][@"province"];
    }else{
        NSInteger section = [pickerView selectedRowInComponent:0];
        if (section >= 0 && section < self.dataSource.count) {
            NSArray *citysArr = self.dataSource[section][@"citys"];
            if (row < citysArr.count) {
                return citysArr[row][@"city"];
            }else{
                return @"";
            }
        }else{
            return @"";
        }
    }
}

#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        [pickerView reloadComponent:1];
        NSInteger section = [pickerView selectedRowInComponent:1];
        if (section >= 0 && section < self.dataSource.count) {
            self.id_value = [NSString stringWithFormat:@"%@,%@",self.dataSource[row][@"province_id"],self.dataSource[row][@"citys"][section][@"city_id"]];
            self.value = [NSString stringWithFormat:@"%@%@",self.dataSource[row][@"province"],self.dataSource[row][@"citys"][section][@"city"]];
        }
    }else{
        NSInteger section = [pickerView selectedRowInComponent:0];
        if (section >= 0 && section < self.dataSource.count) {
            self.id_value = [NSString stringWithFormat:@"%@,%@",self.dataSource[section][@"province_id"],self.dataSource[section][@"citys"][row][@"city_id"]];
            self.value = [NSString stringWithFormat:@"%@%@",self.dataSource[section][@"province"],self.dataSource[section][@"citys"][row][@"city"]];
        }
    }
}

#pragma mark - getter
- (NSString *)value{
    if (!_value || _value.length < 1) {
        _value = [NSString stringWithFormat:@"%@%@",self.dataSource[0][@"province"],self.dataSource[0][@"citys"][0][@"city"]];
    }
    return _value;
}

@end
