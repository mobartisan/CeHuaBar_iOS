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

-(void)layoutSubviews {
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
    }
    if (projects) {
        self.projects = [NSMutableArray arrayWithArray:projects];
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
    }
    return cell;
}

#pragma -mark UIButtonAction
- (IBAction)confirmBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(self,YES);
    }
}

- (IBAction)cancelBtnAction:(id)sender {
    if (self.clickBtnBlock) {
        self.clickBtnBlock(self,NO);
    }
}

#pragma -mark show and hide
- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    if (!self.bgBtn) {
        self.bgBtn = [UIButton hyb_buttonWithSuperView:keyWindow constraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(keyWindow);
        } touchUp:^(UIButton *sender) {
            [self hide];
        }];
    }
    
    [keyWindow addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(keyWindow.mas_left).offset(18);
        make.right.mas_equalTo(keyWindow.mas_right).offset(-18);
        make.bottom.mas_equalTo(keyWindow.mas_bottom);
        make.top.mas_equalTo(keyWindow.mas_top).offset(100);
    }];
}

- (void)hide {
    [self.bgBtn removeFromSuperview];
    [self removeFromSuperview];
}

@end
