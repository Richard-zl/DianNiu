//
//  DNDateSelectControl.m
//  Dianniu
//
//  Created by RIMI on 2017/2/15.
//  Copyright © 2017年 Dianniu. All rights reserved.
//

#import "DNDateSelectControl.h"

@interface DNDateSelectControl ()
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@end

@implementation DNDateSelectControl

- (instancetype)init{
    if (self = [super init]) {
        [self creatAccessoryView];
        [self creatInputView];
    }
    return self;
}


- (void)show{
    [((UIDatePicker *)self.inputView) setDate:[NSDate date]];
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

- (void)dismiss{
    if ([self isFirstResponder]) {
        [self resignFirstResponder];
    }
}

- (void)buttonAction:(UIBarButtonItem *)item{
    if ([item.title isEqualToString:@"确定"]) {
       NSDate * date = ((UIDatePicker *)self.inputView).date;
        if (date && self.didSelected) {
            self.didSelected([self.dateFormatter stringFromDate:date]);
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
    UIDatePicker *pickerView = [[UIDatePicker alloc] init];
    [pickerView setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-Hans"]];
    [pickerView setDatePickerMode:UIDatePickerModeDateAndTime];
    [pickerView setMinimumDate:[NSDate date]];
    self.inputView = pickerView;
}

- (NSDateFormatter *)dateFormatter{
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    return _dateFormatter;
}

@end
