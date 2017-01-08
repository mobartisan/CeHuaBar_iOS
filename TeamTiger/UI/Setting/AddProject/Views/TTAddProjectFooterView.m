//
//  TTAddProjectFooterView.m
//  TeamTiger
//
//  Created by Dale on 17/1/5.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "TTAddProjectFooterView.h"
#import "TTAddMemberCell.h"

@interface TTAddProjectFooterView () <UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIImageView *accessoryImgV;
@end

@implementation TTAddProjectFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self tableView];
        
    }
    return self;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)selectMembers {
    if (_selectMembers == nil) {
        _selectMembers = [NSMutableArray array];
    }
    return _selectMembers;
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = kRGB(27, 41, 58);
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _tableView;
}

- (UIImageView *)accessoryImgV {
    if (_accessoryImgV == nil) {
        self.accessoryImgV = [[UIImageView alloc] init];
        self.accessoryImgV.image = [UIImage imageNamed:@"icon_enter"];
        self.accessoryImgV.contentMode = UIViewContentModeCenter;
        [self addSubview:self.accessoryImgV];
        [self.accessoryImgV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-10);
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.mas_centerY);
        }];
    }
    return _accessoryImgV;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"TTAddMemberCell";
    TTAddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[UINib nibWithNibName:@"TTAddMemberCell" bundle:nil] instantiateWithOwner:nil options:nil] firstObject];
    }
    TT_User *user = self.dataSource[indexPath.row];
    cell.accessoryType = user.isSelect ? UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    cell.user = user;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TT_User *user = self.dataSource[indexPath.row];
    user.isSelect = !user.isSelect;
    [self.tableView reloadData];
    if (user.isSelect) {
        [self.selectMembers addObject:user.user_id];
    } else {
        [self.selectMembers removeObject:user.user_id];
    }
    if (self.addMemberBlock) {
        self.addMemberBlock(self.selectMembers);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return kCellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    static NSString *ID = @"TTAddMemberCell2";
    TTAddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = LoadFromNib(@"TTAddMemberCell2");
    }
    cell.msgLB.text = @"提示信息";
    return cell;
}

@end
