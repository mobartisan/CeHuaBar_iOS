//
//  DiVideGroupCell.m
//  TeamTiger
//
//  Created by Dale on 16/12/26.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DiVideGroupCell.h"
#import "GroupCollectionViewCell.h"
#import "YTAnimation.h"




@interface DiVideGroupCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@end

@implementation DiVideGroupCell

+ (instancetype)cellWithTableView:(UITableView *)tableView  {
    static NSString *cellID = @"DiVideGroupCell";
    DiVideGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[DiVideGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    return cell;
}

+ (CGFloat)heightOfProjectsView:(NSArray *)projects {
    NSInteger count = projects.count;
    NSInteger rows = ceil((count + 1) / 3.0);
    return (rows + 1) * 5.0 + rows * kSizeHeight;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [Common colorFromHexRGB:@"151b27"];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(kSizeWidth, kSizeHeight);
        flowLayout.minimumLineSpacing = 5.0;
        flowLayout.minimumInteritemSpacing = 5.0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 20 * 2, 50) collectionViewLayout:flowLayout];
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [Common colorFromHexRGB:@"151b27"];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[GroupCollectionViewCell class] forCellWithReuseIdentifier:@"GroupCollectionViewCell"];
        [self.contentView addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

#pragma mark UICollectionViewDelegate && DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCollectionViewCell" forIndexPath:indexPath];
    
    TT_Group *group = nil;
    if (indexPath.row != self.dataSource.count) {
        group = self.dataSource[indexPath.row];
    }
    cell.group = group;
    
    cell.clickGroupBlock = ^(TT_Group *tmpGroup) {
        if (self.clickGroupBlock) {
            self.clickGroupBlock(tmpGroup);
        }
    };
    cell.clickAddGroupBlock = ^() {
        if (self.clickAddGroupBlock) {
            self.clickAddGroupBlock();
        }
    };
    cell.clickDeleteBtnBlock = ^(TT_Group *tmpGroup) {
        if (self.clickDeleteBtnBlock) {
            self.clickDeleteBtnBlock(tmpGroup);
        }
    };
//    cell.longPressItemBlock = ^() {
//        [self.collectionView reloadData];
//    };
    return cell;
}


- (void)layoutSubviews {
    NSInteger count = self.dataSource.count;
    NSInteger rows = ceil((count + 1) / 3.0);
    CGFloat collectionH =  (rows + 1) * 5.0 + rows * kSizeHeight;
    self.collectionView.frame = CGRectMake(20, 0, kScreenWidth - 20 * 2, collectionH);
}

@end
