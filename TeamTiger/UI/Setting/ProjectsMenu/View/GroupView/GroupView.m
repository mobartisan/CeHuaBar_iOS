//
//  GroupView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupView.h"
#import "MBProgressHUD.h"

@interface GroupView ()<UITextFieldDelegate>

@property(nonatomic,strong)UIButton *bgBtn;

@end

@implementation GroupView
- (void)awakeFromNib {
    [super awakeFromNib];
    
    setViewCorner(self.nameTxtField, 5);
    UIView *v = [[UIView alloc] init];
    SetFrameByXPos(v.frame, 0);
    SetFrameByYPos(v.frame, 0);
    SetFrameByWidth(v.frame, 10);
    SetFrameByHeight(v.frame, self.nameTxtField.frame.Height);

    self.nameTxtField.leftView = v;
    self.nameTxtField.leftViewMode = UITextFieldViewModeAlways;
    [self.nameTxtField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [Common removeExtraCellLines:self.table];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}


- (void)loadGroupInfo:(id)groupInfo AllProjects:(NSArray *)projects {
    self.projects = [NSMutableArray arrayWithArray:projects];
    self.selProjects = [NSMutableArray array];
    if (groupInfo) {
        self.groupInfo = [NSMutableDictionary dictionaryWithDictionary:groupInfo];
        self.nameTxtField.text = self.groupInfo[@"Name"];
        NSArray *pids = [self.groupInfo[@"Pids"] componentsSeparatedByString:@","];
        [self.projects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([pids containsObject:obj[@"Id"]] ) {
                [self.selProjects addObject:@1];
            } else {
                [self.selProjects addObject:@0];
            }
        }];
    } else {
        self.groupInfo = [NSMutableDictionary dictionary];
        [self.projects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.selProjects addObject:@0];
        }];
    }
    [self.table reloadData];
}

#pragma -mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.projects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.projects[indexPath.row][@"Name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [Common colorFromHexRGB:@"333333"];
    if ([self.selProjects[indexPath.row] intValue] == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *number = self.selProjects[indexPath.row];
    if (number.intValue == 0) {
        number = @1;
    } else {
        number = @0;
    }
    [self.selProjects replaceObjectAtIndex:indexPath.row withObject:number];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"项目";
    titleLab.textColor = ColorRGB(157.0, 157.0, 157.0);
    titleLab.font = [UIFont systemFontOfSize:12];
    [view addSubview:titleLab];
    [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.top.equalTo(view.mas_top).offset(10);
        make.bottom.equalTo(view.mas_bottom);
        make.right.equalTo(view.mas_right);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.0;
}

#pragma -mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma -mark UIButtonAction
- (IBAction)confirmBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        if ([Common isEmptyString:self.nameTxtField.text]) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.label.text = @"组名称不能为空";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0];
            return;
        }
        
        id count = [self.selProjects valueForKeyPath:@"@sum.intValue"];
        if ([count intValue] == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.label.text = @"组必须包含至少一个项目";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0];
            return;
        }
        
        if (self.groupInfo) {
            self.groupInfo[@"Name"] = self.nameTxtField.text;
            NSMutableString *mString = [NSMutableString string];
            [self.projects enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([self.selProjects[idx] intValue] == 1) {
                    [mString appendFormat:@"%@,",obj[@"Id"]];
                }
            }];
            NSUInteger length = mString.length;
            [mString replaceOccurrencesOfString:@"," withString:@"" options:NSBackwardsSearch range:NSMakeRange(length - 1, 1)];
            self.groupInfo[@"Pids"] = mString;
        }
        //creat
        NSString *uuid = [[[NSUUID UUID].UUIDString stringByReplacingOccurrencesOfString:@"-" withString:NullString] lowercaseString];
        self.groupInfo[@"Gid"] = uuid;
        self.clickBtnBlock(self, YES, self.groupInfo);
    }
    [self hide];
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(self, NO, nil);
    }
    [self hide];
}

#pragma -mark show and hide
- (void)show {
    if (!self.isShow) {
        self.isShow = YES;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        if (!self.bgBtn) {
            self.bgBtn = [UIButton hyb_buttonWithSuperView:keyWindow constraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(keyWindow);
            } touchUp:^(UIButton *sender) {
                [self hide];
            }];
            [self.superview layoutIfNeeded];
        }
        
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyWindow.mas_left).offset(18);
            make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
            make.top.mas_equalTo(keyWindow.mas_top).offset(100);
            make.height.mas_equalTo(Screen_Height - 100);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.superview layoutIfNeeded];
        }];
        [keyWindow bringSubviewToFront:self];
        
        //初始化
        self.nameTxtField.text = nil;
    }
}

- (void)hide {
    if (self.isShow) {
        self.isShow = NO;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [self mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(keyWindow.mas_left).offset(18);
            make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
            make.top.mas_equalTo(keyWindow.mas_top).offset(Screen_Height);
            make.height.mas_equalTo(Screen_Height - 100);
        }];
        [UIView animateWithDuration:0.3 animations:^{
            [self.superview layoutIfNeeded];
        }];
        [self.bgBtn removeFromSuperview];
        self.bgBtn = nil;
        //
        [self.nameTxtField resignFirstResponder];
    }
}

@end
