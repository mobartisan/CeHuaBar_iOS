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

#define  _MaxLength  40

@interface SettingCell ()

@property (strong, nonatomic) UIView *leftView;

@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    setViewCorner(self.createBtn, 5);
    self.createBtn.layer.borderWidth = 1.5;
    self.createBtn.layer.borderColor = [UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1].CGColor;

    [self.createBtn setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:23.0 / 255.0 green:174.0 / 255.0 blue:175.0 / 255.0 alpha:1]] forState:UIControlStateHighlighted];
    
    [self.createBtn setTitleColor:[UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:39.0/255.0f alpha:1.0f] forState:UIControlStateHighlighted];
    
    [self.createBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        self.textField.textAlignment = NSTextAlignmentRight;
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
        case ECellTypeProjectIcon:{
            self.accessoryImgV = [[UIImageView alloc] init];
            self.accessoryImgV.image = [UIImage imageNamed:@"icon_enter"];
            self.accessoryImgV.contentMode = UIViewContentModeCenter;
            [self.contentView addSubview:self.accessoryImgV];
            [self.accessoryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
                make.width.equalTo(@20);
                make.height.equalTo(@20);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            
            self.projectIcon = [[UIImageView alloc] init];
            self.projectIcon.image = kImage(@"img_logo");
            setViewCorner(self.projectIcon, 4.0);
            [self.contentView addSubview:self.projectIcon];
            [self.projectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.accessoryImgV.mas_left).offset(-5);
                make.width.equalTo(@40);
                make.height.equalTo(@40);
                make.centerY.equalTo(self.contentView.mas_centerY);
            }];
            
            self.addProjectIcon = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.addProjectIcon addTarget:self action:@selector(handleAddProjectIcon) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.addProjectIcon];
            [self.addProjectIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
            break;
        }
        case ECellTypeProjectName:{//@"Type something..."
            self.textField = [UITextField hyb_textFieldWithHolder:@"请输入项目名称" text:nil delegate:self superView:self.contentView constraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.titleLab.mas_right).offset(10);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
            self.textField.enablesReturnKeyAutomatically = YES;
            [self.textField setValue:[UIColor colorWithWhite:0.7 alpha:0.5] forKeyPath:@"_placeholderLabel.textColor"];
            self.textField.font = [UIFont systemFontOfSize:17];
            self.textField.textColor = [UIColor whiteColor];
            self.textField.tintColor = [UIColor whiteColor];
            self.textField.returnKeyType = UIReturnKeyDone;
            [self.textField addTarget:self action:@selector(textLengthChange:) forControlEvents:UIControlEventEditingChanged];
            break;
        }
        case ECellTypeSearch:{
            self.searchTF = [UITextField hyb_textFieldWithHolder:@"名字/微信号" text:nil delegate:nil superView:self.contentView constraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView.mas_centerX).offset(-50);
                make.left.equalTo(self.contentView).offset(16);
                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
            }];
            
            self.searchTF.leftView = self.leftView;
            self.searchTF.leftViewMode = UITextFieldViewModeAlways;
            self.searchTF.returnKeyType = UIReturnKeySearch;
            self.searchTF.textColor = [UIColor whiteColor];
            self.searchTF.tintColor = [UIColor whiteColor];
//            [self.searchTF setValue:kRGB(42, 56, 72) forKeyPath:@"_placeholderLabel.textColor"];
            self.searchTF.font = [UIFont systemFontOfSize:17];
            break;
        }
        case ECellTypeAddMember:{
            self.addMemberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [self.addMemberBtn addTarget:self action:@selector(handleAddMemberAction) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:self.addMemberBtn];
            [self.addMemberBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.contentView);
            }];
//            [self.addMemberBtn setTitle:@"添加成员到项目" forState:UIControlStateNormal];
//            [self.addMemberBtn setImage:kImage(@"icon_add_members") forState:UIControlStateNormal];
//            self.addMemberBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
//            [self.addMemberBtn setTitleEdgeInsets:UIEdgeInsetsMake(self.addMemberBtn.imageView.frame.size.height + 10, -self.addMemberBtn.imageView.frame.size.width, 0.0, 0.0)];
//            [self.addMemberBtn setImageEdgeInsets:UIEdgeInsetsMake(-20.0, 0.0,0.0, -self.addMemberBtn.titleLabel.bounds.size.width)];
//            self.backgroundColor = kRGB(28, 37, 51);
            break;
        }
        case ECellTypeBottom:{
            break;
        }
        default:
            break;
    }
}

- (UIView *)leftView {
    if (_leftView == nil) {
        _leftView = [[UIView alloc] init];
        _leftView.frame = CGRectMake(0, 0, 25, 15);
        UIImageView *leftImV = [[UIImageView alloc] init];
        leftImV.image = kImage(@"icon_search");
        leftImV.frame = CGRectMake(5, 0, 15, 15);
        [_leftView addSubview:leftImV];
    }
    return _leftView;
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

- (void)handleAddProjectIcon {
    if (self.actionBlock) {
        self.actionBlock(self, ECellTypeProjectIcon, self.projectIcon);
    }
}

- (void)textLengthChange:(UITextField *)textField {
    [self textFieldDidChange:textField];
    if (self.actionBlock) {
        self.actionBlock(self, ECellTypeProjectName, textField.text);
    }
}

- (void)textFieldDidChange:(UITextField *)textField
{
    NSString *text = textField.text;
    //    NSLog(@"text:%@",text);
    
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制,防止中文被截断
    
    if (!position){
        //---字节处理
        //Limit
        NSUInteger textBytesLength = [textField.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
        if (textBytesLength > _MaxLength) {
            self.hud = [MBProgressHUD showHUDAddedTo:self.superview.superview animated:YES];
            self.hud.label.text = @"字数超过上限";
            self.hud.mode = MBProgressHUDModeText;
            [self.hud hideAnimated:YES afterDelay:1.5];
            
            NSRange range;
            NSUInteger byteLength = 0;
            for(int i = 0; i < text.length && byteLength <= _MaxLength; i += range.length) {
                range = [textField.text rangeOfComposedCharacterSequenceAtIndex:i];
                byteLength += strlen([[text substringWithRange:range] UTF8String]);
                if (byteLength > _MaxLength) {
                    NSString* newText = [text substringWithRange:NSMakeRange(0, range.location)];
                    textField.text = newText;
                }
            }
        }
    }
}


- (void)handleAddMemberAction {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (self.actionBlock) {
        self.actionBlock(self, ECellTypeAddMember, nil);
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([Common isEmptyString:textField.text]) {
        if (textField == self.textField) {
            self.textField.textAlignment = NSTextAlignmentLeft;
        }
//        else {
//            [self.searchTF mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView.mas_left).offset(10);
//                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
//                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
//            }];
//        }
    } else {
        if (textField == self.textField) {
            self.textField.textAlignment = NSTextAlignmentLeft;
        }
//        else {
//            [self.searchTF mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView.mas_left).offset(10);
//                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
//                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
//            }];
//        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([Common isEmptyString:textField.text]) {
        if (textField == self.textField) {
            self.textField.textAlignment = NSTextAlignmentLeft;
        }
//        else {
//            [self.searchTF mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView.mas_centerX).offset(-50);
//                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
//                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
//            }];
//        }
    } else {
        if (textField == self.textField) {
            self.textField.textAlignment = NSTextAlignmentRight;
        }
//        else {
//            [self.searchTF mas_remakeConstraints:^(MASConstraintMaker *make) {
//                make.left.mas_equalTo(self.contentView.mas_left).offset(10);
//                make.right.mas_equalTo(self.contentView.mas_right).offset(-20);
//                make.top.mas_equalTo(self.contentView.mas_top).offset(22);
//                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-20);
//            }];
//        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.textField) {
        if ([string isEqualToString:@"\n"]) {
            [textField resignFirstResponder];
//            if ([Common isEmptyString:textField.text]) {
//                return NO;
//            }
//            if (self.actionBlock) {
//                self.actionBlock(self, ECellTypeProjectAdd, textField.text);
//            }
            return NO;
        }
    }
    return YES;
}


@end
