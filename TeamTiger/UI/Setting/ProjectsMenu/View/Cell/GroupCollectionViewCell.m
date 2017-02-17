//
//  GroupCollectionViewCell.m
//  TeamTiger
//
//  Created by Dale on 16/12/26.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupCollectionViewCell.h"

@interface GroupCollectionViewCell()

@property(nonatomic,strong) UILabel *projectNameLabel;
@property(nonatomic,strong) UILabel *msgLabel;
@property(nonatomic,strong) UIImageView *unreadMsgImgV;
@property(nonatomic,strong) UIButton *addBtn;
@property (strong, nonatomic) UIButton *deleteBtn;

@end

@implementation GroupCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [Common colorFromHexRGB:@"21344e"];
        [self msgLabel];
        [self projectNameLabel];
        [self unreadMsgImgV];
        [self addBtn];
        [self deleteBtn];
    }
    return self;
}

- (void)setGroup:(TT_Group *)group {
    _group = group;
    if (!group) {
        [self isHidden:YES];
        [self.addBtn setImage:kImage(@"icon_add_group") forState:UIControlStateNormal];
        [self.addBtn removeTarget:self action:@selector(handleGroupAction) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn addTarget:self action:@selector(handleAddGroupAction) forControlEvents:UIControlEventTouchUpInside];
    }else {
        [self isHidden:NO];
        if (self.count != [CirclesManager sharedInstance].views.count) {
            [[CirclesManager sharedInstance].views addObject:self];
        }
        
        self.msgLabel.text = @(group.project_nums).stringValue;
        self.projectNameLabel.text = group.group_name;
        if ([self.msgLabel.text intValue] == 0) {
            self.unreadMsgImgV.hidden = YES;
            self.msgLabel.hidden = YES;
        } else {
            self.unreadMsgImgV.hidden = NO;
            self.msgLabel.hidden = NO;
        }
        //未读消息个数
        if (group.newscount > 0) {
            self.unreadMsgImgV.hidden = NO;
            self.unreadMsgImgV.backgroundColor = [UIColor redColor];
        } else {
            self.unreadMsgImgV.hidden = YES;
        }
        
        [self.addBtn setImage:nil forState:UIControlStateNormal];
        [self.addBtn removeTarget:self action:@selector(handleAddGroupAction) forControlEvents:UIControlEventTouchUpInside];
        [self.addBtn addTarget:self action:@selector(handleGroupAction) forControlEvents:UIControlEventTouchUpInside];
        
        //        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressItem:)];
        //        longPress.minimumPressDuration = 0.8; //定义按的时间
        //        [self.addBtn addGestureRecognizer:longPress];
    }
}


- (void)isHidden:(BOOL)isHidden {
    self.msgLabel.hidden = isHidden;
    self.projectNameLabel.hidden = isHidden;
    self.unreadMsgImgV.hidden = isHidden;
}

//添加分组
- (void)handleAddGroupAction {
    if (self.clickAddGroupBlock) {
        self.clickAddGroupBlock();
    }
}
//点击分组
- (void)handleGroupAction {
    if (self.clickGroupBlock) {
        self.clickGroupBlock(_group);
    }
}
//删除分组
- (void)handleDeleteBtnAction {
    if (self.clickDeleteBtnBlock) {
        self.clickDeleteBtnBlock(_group);
    }
}

- (void)longPressItem:(UILongPressGestureRecognizer *)gestureRecognizer{
    [(UIButton *)gestureRecognizer.view removeTarget:self action:@selector(handleGroupAction) forControlEvents:UIControlEventTouchUpInside];
    [(UIButton *)gestureRecognizer.view removeTarget:self action:@selector(handleAddGroupAction) forControlEvents:UIControlEventTouchUpInside];
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        if (self.longPressItemBlock) {
            self.longPressItemBlock();
        }
    }
}
#pragma -mark getter
- (UILabel *)projectNameLabel {
    if (!_projectNameLabel) {
        _projectNameLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_projectNameLabel];
        [_projectNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(50);
            make.width.equalTo(self.mas_width).offset(-5);
        }];
        _projectNameLabel.textColor = [Common colorFromHexRGB:@"ffffff"];
        _projectNameLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _projectNameLabel;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        [self.contentView addSubview:_msgLabel];
        [_msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0).offset(2);
            make.bottom.mas_equalTo(0);
            make.width.equalTo(self.mas_width);
            make.height.equalTo(self.mas_height).offset(-20);
        }];
        _msgLabel.textColor = [Common colorFromHexRGB:@"2e3a4a"];
        _msgLabel.textAlignment = NSTextAlignmentRight;
        _msgLabel.font = [UIFont boldSystemFontOfSize:75];
    }
    return _msgLabel;
}

- (UIImageView *)unreadMsgImgV {
    if (!_unreadMsgImgV) {
        _unreadMsgImgV = [[UIImageView alloc] init];
        [self.contentView addSubview:_unreadMsgImgV];
        [_unreadMsgImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(8);
            make.top.mas_equalTo(8);
            make.width.mas_equalTo(8);
            make.height.mas_equalTo(8);
        }];
        setViewCorner(_unreadMsgImgV, 4);
    }
    return _unreadMsgImgV;
}

- (UIButton *)addBtn {
    if (!_addBtn) {
        _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.contentView addSubview:_addBtn];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _addBtn;
}

- (UIButton *)deleteBtn {
    if (!_deleteBtn) {
        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteBtn.hidden = YES;
        [_deleteBtn setImage:[UIImage imageNamed:@"icon_delete-group"] forState:UIControlStateNormal];
        [_deleteBtn addTarget:self action:@selector(handleDeleteBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteBtn];
        [_deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
            make.width.mas_equalTo(20);
            make.height.mas_equalTo(20);
        }];
    }
    return _deleteBtn;
}


- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
