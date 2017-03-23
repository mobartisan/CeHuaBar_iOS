//
//  ProfileCell.m
//  TeamTiger
//
//  Created by xxcao on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProjectCell.h"
#import "UIButton+HYBHelperBlockKit.h"
#import "ItemView.h"

@implementation ProjectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    setViewCorner(self.exitBtn, 5);
}

+ (instancetype)loadCellWithType:(int)type {
    ProjectCell *cell = nil;
    switch (type) {
        case 0:
            cell = LoadFromNib(@"ProjectCell1");
            cell.contentView.backgroundColor = kColorForCommonCellBackgroud;
            break;
        case 1:
            cell = LoadFromNib(@"ProjectCell1");
            cell.contentView.backgroundColor = kColorForCommonCellBackgroud;
            break;
        case 2:
            cell = LoadFromNib(@"ProjectCell_Member");
            cell.contentView.backgroundColor = kColorForCommonCellBackgroud;
            break;
        default:
            cell = LoadFromNib(@"ProjectCell2");
            break;
    }
    return cell;
}

+ (CGFloat)loadCellHeightWithData:(id)obj {
    if ([obj[@"Type"] intValue] == 2) {
        NSArray *array = obj[@"Members"];
        return 70.0 + itemSize * ceil((array.count + 1) / 4.0);
    }
    return 70.0;
}

- (void)reloadCellData:(id)obj{
    
    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:obj];
    self.bgImgV.backgroundColor = dic[@"Color"];
    self.nameLab.text = dic[@"Name"];
    self.detailTxtField.text = dic[@"Description"];

    if ([dic[@"ShowAccessory"] intValue]) {
        self.accessoryImgV.hidden = NO;
    } else {
        self.accessoryImgV.hidden = YES;
    }

    if ([dic[@"IsEdit"] intValue]) {
        self.detailTxtField.userInteractionEnabled = YES;
    } else {
        self.detailTxtField.userInteractionEnabled = NO;
    }
    
    
    if ([dic[@"Type"] intValue] == 0) {
        [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(self.contentView.mas_left).offset(60);
        } touchUp:^(UIButton *sender) {
            if (self.block) {
                self.block(self,EProjectSelect);//选择项目
            }
        }];
    } else if ([dic[@"Type"] intValue] == 1) {
        [UIButton hyb_buttonWithSuperView:self.contentView constraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top);
            make.right.mas_equalTo(self.contentView.mas_right);
            make.bottom.mas_equalTo(self.contentView.mas_bottom);
            make.left.mas_equalTo(self.contentView.mas_left).offset(60);
        } touchUp:^(UIButton *sender) {
            if (self.block) {
                self.block(self,EProjectGroup);//选择组
            }
        }];
    }
    else if ([dic[@"Type"] intValue] == 2){
        UIView *contentView = [[UIView alloc] init];
        [self.scrollView addSubview:contentView];
        [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
        
        __block UIView *lastView1 = nil, *lastView2 = nil, *lastView3 = nil, *lastView4 = nil;
        NSArray *members = dic[@"Members"];
        NSUInteger count = (NSUInteger)members.count;
        for (int i = 0; i < count + 1; i++) {
            ItemView *tmpView = nil;
            if (i == count) {
                tmpView = [[ItemView alloc] initWithData:nil];
            } else {
                tmpView = [[ItemView alloc] initWithData:members[i]];
            }
            WeakSelf;
            tmpView.didSelectBlock = ^(ItemView *view){
                if (wself.block) {
                    wself.block(wself,EProjectAddMember);//删除并退出
                }
            };

            [self.scrollView addSubview:tmpView];
            [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(itemSize));
                make.height.equalTo(@(itemSize));
                make.left.mas_equalTo(itemSize * (i % 4));
                if (i % 4 == 0) {
                    if (lastView1){
                        make.top.mas_equalTo(lastView1.mas_bottom);
                    } else {
                        make.top.mas_equalTo(contentView.mas_top);
                    }
                    lastView1 = tmpView;
                } else if (i % 4 == 1) {
                    if (lastView2){
                        make.top.mas_equalTo(lastView2.mas_bottom);
                    } else {
                        make.top.mas_equalTo(contentView.mas_top);
                    }
                    lastView2 = tmpView;
                } else if (i % 4 == 2) {
                    if (lastView3){
                        make.top.mas_equalTo(lastView3.mas_bottom);
                    } else {
                        make.top.mas_equalTo(contentView.mas_top);
                    }
                    lastView3 = tmpView;
                } else {
                    if (lastView4){
                        make.top.mas_equalTo(lastView4.mas_bottom);
                    } else {
                        make.top.mas_equalTo(contentView.mas_top);
                    }
                    lastView4 = tmpView;
                }
            }];
        }
        [contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(lastView1.mas_bottom);
        }];
    }
}

- (IBAction)clickExitBtnAction:(id)sender {
    if (self.block) {
        self.block(self,EProjectDleteProject);//删除并退出
    }
}

@end
