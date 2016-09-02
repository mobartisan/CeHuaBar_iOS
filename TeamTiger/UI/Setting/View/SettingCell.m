//
//  SettingCell.m
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SettingCell.h"
#import "UITextField+HYBMasonryKit.h"
#import "UIButton+HYBHelperBlockKit.h"
#import "TTFadeSwitch.h"
#import "UITextView+PlaceHolder.h"
#import "UIControl+YYAdd.h"
#import "UIImage+YYAdd.h"

@implementation SettingCell

- (void)awakeFromNib {
    setViewCorner(self.createBtn, 5);
    self.createBtn.layer.borderColor = [UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1].CGColor;
    self.createBtn.layer.borderWidth = minLineWidth;

    [self.createBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    [self.createBtn setTitleColor:[UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    [self.createBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (self.actionBlock) {
            self.actionBlock(self, ECellTypeBottom, nil);
        }
    }];
}

+ (instancetype)loadCellWithData:(id)data {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:data];
    if ([dic[@"TYPE"] intValue] == ECellTypeBottom) {
        return LoadFromNib(@"SettingCell2");
    }
    return LoadFromNib(@"SettingCell");
}

- (void)reloadCell:(id)obj {
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
    self.titleLab.text = dic[@"TITLE"];

    switch ([dic[@"TYPE"] intValue]) {
        case ECellTypeTextField:{
            self.textField = [UITextField hyb_textFieldWithHolder:@"请输入名称" text:nil delegate:self superView:self.contentView constraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLab.mas_right).offset(-20);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
            self.textField.textColor = [UIColor whiteColor];
            self.textField.tintColor = [UIColor whiteColor];
            [self.textField setValue:[UIColor lightTextColor] forKeyPath:@"_placeholderLabel.textColor"];
            self.textField.font = [UIFont systemFontOfSize:15];
            break;
        }
        case ECellTypeTextView:{
            [self.titleLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentView.mas_left).offset(16);
                make.top.mas_equalTo(self.contentView.mas_top).offset(28);
                make.width.equalTo(@68);
            }];
            self.textView = [[UITextView alloc] init];
            self.textView.showsVerticalScrollIndicator = NO;
            self.textView.showsHorizontalScrollIndicator = NO;
            self.textView.scrollEnabled = NO;
            self.textView.delegate = self;
            self.textView.textColor = [UIColor whiteColor];
            self.textView.font = [UIFont systemFontOfSize:15];
            self.textView.backgroundColor = [UIColor clearColor];
            self.textView.tintColor = [UIColor whiteColor];
            [self.contentView addSubview:self.textView];
            [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLab.mas_right).offset(-24);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
            self.textView.placeholder = @"请输入描述";
            self.textView.maxLength = 200;//最大字数
            break;
        }

        case ECellTypeSwitch:{
            // Fade mode
            self.tSwitch = [[TTFadeSwitch alloc] init];
            self.tSwitch.thumbImage = [UIImage imageNamed:@"toggle_handle_on"];
            self.tSwitch.thumbOffImage = [UIImage imageNamed:@"toggle_handle_off"];
            self.tSwitch.thumbHighlightImage = [UIImage imageNamed:@"toggle_handle_on"];
            self.tSwitch.trackMaskImage = [UIImage imageNamed:@"toggle_background_off"];
            self.tSwitch.trackImageOn = [UIImage imageNamed:@"toggle_background_on"];
            self.tSwitch.trackImageOff = [UIImage imageNamed:@"toggle_background_off"];
            self.tSwitch.thumbInsetX = -3.0;
            self.tSwitch.thumbOffsetY = 0.0;
            [self.contentView addSubview:self.tSwitch];
            [self.tSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.width.equalTo(@51.5);
                make.height.equalTo(@31);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            __weak __typeof(self)wself = self;
            self.tSwitch.changeHandler = ^(BOOL on){
                if (wself.actionBlock) {
                    wself.actionBlock(wself, ECellTypeSwitch, @(on));
                }
            };
            break;
        }

        case ECellTypeAccessory:{
            self.accessoryImgV = [[UIImageView alloc] init];
            self.accessoryImgV.image = [UIImage imageNamed:@"icon_enter"];
            self.accessoryImgV.contentMode = UIViewContentModeCenter;
            [self.contentView addSubview:self.accessoryImgV];
            [self.accessoryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            
            [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 100, 0, 0));
            } touchUp:^(UIButton *sender) {
                if (self.actionBlock) {
                    self.actionBlock(self,ECellTypeAccessory,nil);
                }
            }];
            break;
        }
        case ECellTypeBottom:{
            break;
        }
        default:
            break;
    }
}


- (void)textViewDidChange:(UITextView *)textView {
    UITableView *tableView = [self tableView];
    CGPoint currentOffset = tableView.contentOffset;
    [UIView setAnimationsEnabled:NO];
    [tableView beginUpdates];
    [tableView endUpdates];
    [UIView setAnimationsEnabled:YES];
    [tableView setContentOffset:currentOffset animated:NO];
}

- (UITableView *)tableView {
    UIView *tableView = self.superview;
    while (![tableView isKindOfClass:[UITableView class]] && tableView) {
        tableView = tableView.superview;
    }
    return (UITableView *)tableView;
}


- (void)textViewDidEndEditing:(UITextView *)textView {
    if (self.actionBlock) {
        self.actionBlock(self, ECellTypeTextView, textView.text);
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (self.actionBlock) {
        self.actionBlock(self, ECellTypeTextField, textField.text);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
