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
        
        UIView *bgView = [[UIView alloc] init];
        bgView.backgroundColor = kRGB(27, 41, 58);
        _tableView.backgroundView = bgView;
        _tableView.sectionIndexColor = [UIColor whiteColor];
        _tableView.sectionIndexBackgroundColor = kRGB(27, 41, 58);
        _tableView.rowHeight = kCellHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.top.equalTo(self).offset(1);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _tableView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TT_Project_Members *user = self.dataSource[indexPath.row];
    
    static NSString *ID = @"TTAddMemberCell";
    TTAddMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        if ([Common isEmptyString:user.user_id]) {
            cell = LoadFromNib(@"TTAddMemberCell2");
        } else {
            cell = LoadFromNib(@"TTAddMemberCell");
        }
    }
    cell.icon_confirm.hidden = !user.isSelect;
    cell.user = user;
    [cell setSelectBtnBlock:^(TTAddMemberCellType type) {
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
    }];
    return cell;
}


@end
