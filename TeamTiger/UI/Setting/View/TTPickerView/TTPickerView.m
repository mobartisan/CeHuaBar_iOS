//
//  TTPickerView.m
//  TeamTiger
//
//  Created by xxcao on 16/8/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTPickerView.h"

@implementation TTPickerView

- (instancetype)initWithDatas:(NSArray *)datas SelectBlock:(TTPickerViewBlock)block TapBlock:(TTTapBlock)tapBlock {

    self = [super init];
    if (self) {
        _dataSources = [NSMutableArray arrayWithArray:datas];

        _picker = [[UIPickerView alloc] init];
        [self addSubview:_picker];
        _picker.delegate = self;
        [_picker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(200);
        }];
        [_picker reloadAllComponents];
        
        _pickerBlock = [block copy];
        
        _tapBlock = [tapBlock copy];
        
        
        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGR];

    }
    return self;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.dataSources.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.dataSources[row][@"Name"];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel *pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8.0;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        pickerLabel.textAlignment = NSTextAlignmentCenter;
        pickerLabel.backgroundColor = [UIColor clearColor];
        pickerLabel.font = [UIFont boldSystemFontOfSize:18.0];
        pickerLabel.textColor = [UIColor whiteColor];
    }
    pickerLabel.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    //在该代理方法里添加以下两行代码删掉上下的黑线
    [pickerView.subviews[1] setHidden:YES];
    [pickerView.subviews[2] setHidden:YES];
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.pickerBlock) {
        self.pickerBlock(self, self.dataSources[row]);
    }
}

- (void)tapAction:(id)sender {
    if (self.tapBlock) {
        self.tapBlock(self);
    }
}

@end
