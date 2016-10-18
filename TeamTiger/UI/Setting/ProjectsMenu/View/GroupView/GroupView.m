//
//  GroupView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupView.h"

@interface GroupView ()

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
    if (groupInfo) {
        self.groupInfo = [NSMutableDictionary dictionaryWithDictionary:groupInfo];
        self.projects = [NSMutableArray arrayWithArray:projects];
        //TO DO
        //self.selProjects 处理
    } else {
        self.selProjects = [NSMutableArray array];
        self.projects = [NSMutableArray arrayWithArray:projects];
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

#pragma -mark UIButtonAction
- (IBAction)confirmBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(self,YES);
    }
    [self hide];
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(self,NO);
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
