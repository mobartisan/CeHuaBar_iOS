//
//  GroupView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "SelectGroupView.h"
#import "MBProgressHUD.h"

@interface SelectGroupView ()

@property(nonatomic,strong)UIButton *bgBtn;

@end

@implementation SelectGroupView
- (void)awakeFromNib {
    [super awakeFromNib];
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


- (void)loadGroups:(NSArray *)groups {
    self.groups = [NSMutableArray arrayWithArray:groups];
    self.selGroups = [NSMutableArray array];
    [self.groups enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.selGroups addObject:@0];
    }];
    [self.table reloadData];
}

#pragma -mark
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"CellIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = self.groups[indexPath.row][@"Name"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [Common colorFromHexRGB:@"333333"];
    if ([self.selGroups[indexPath.row] intValue] == 0) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *array = [NSArray arrayWithArray:self.selGroups];
    NSInteger count = array.count;
    for (int i = 0; i < count; i++) {
        if ([array[i] intValue] == 1) {
            [self.selGroups replaceObjectAtIndex:i withObject:@0];
        }
    }
    [self.selGroups replaceObjectAtIndex:indexPath.row withObject:@1];
    [tableView reloadData];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    titleLab.text = @"项目组";
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

#pragma -mark UIButtonAction
- (IBAction)confirmBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        id count = [self.selGroups valueForKeyPath:@"@sum.intValue"];
        if ([count intValue] == 0) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.superview animated:YES];
            hud.label.text = @"请先选择一个分组";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:1.0];
            return;
        }
        id groupInfo = nil;
        NSInteger tmpCount = self.selGroups.count;
        for (int i = 0; i < tmpCount; i++) {
            if ([self.selGroups[i] intValue] == 1) {
                groupInfo = self.groups[i];
                break;
            }
        }
        self.clickBtnBlock(self, YES, groupInfo);
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
    }
}

@end
