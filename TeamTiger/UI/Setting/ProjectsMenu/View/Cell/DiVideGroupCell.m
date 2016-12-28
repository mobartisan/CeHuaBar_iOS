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

#define  kSizeWidth   ((Screen_Width - 50) / 3.0)
#define  kSizeHeight   75.0


@interface DiVideGroupCell()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (assign, nonatomic) BOOL deleteBtnFlag;
@property (assign, nonatomic) BOOL vibrateAniFlag;


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
        self.contentView.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        self.deleteBtnFlag = YES;
        self.vibrateAniFlag = YES;
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
        UIView *v = [[UIView alloc] init];
        v.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        _collectionView.backgroundView = v;
        _collectionView.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        
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
    if (indexPath.row != self.dataSource.count && ![Common isEmptyArr:self.dataSource]) {
        [self setCellVibrate:cell IndexPath:indexPath];
    }
    TT_Group *group = nil;
    if (indexPath.row != self.dataSource.count) {
        group = self.dataSource[indexPath.row];
        [cell configureCellWithGroup:group];
        
    } else {
        [cell configureCellWithGroup:group];
    }
    cell.clickGroupBlock = ^() {
        if (self.clickGroupBlock) {
            self.clickGroupBlock();
        }
    };
    cell.clickAddGroupBlock = ^() {
        if (self.clickAddGroupBlock) {
            self.clickAddGroupBlock();
        }
    };
    cell.longPressItemBlock = ^() {
        self.deleteBtnFlag = NO;
        self.vibrateAniFlag = NO;
        [self.collectionView reloadData];
    };
    cell.clickDeleteBtnBlock = ^(NSIndexPath *tmpIndexPath) {
        self.deleteBtnFlag = YES;
        self.vibrateAniFlag = YES;
        if (self.clickDeleteBtnBlock) {
            self.clickDeleteBtnBlock(tmpIndexPath);
        }
    };
    return cell;
}

- (void)setCellVibrate:(GroupCollectionViewCell *)cell IndexPath:(NSIndexPath *)indexPath{
    cell.indexPath = indexPath;
    cell.deleteBtn.hidden = self.deleteBtnFlag ? YES : NO;
    if (!self.vibrateAniFlag) {
        [YTAnimation vibrateAnimation:cell];
    }else{
        [self.layer removeAnimationForKey:@"shake"];
    }
}


- (void)layoutSubviews {
    NSInteger count = self.dataSource.count;
    NSInteger rows = ceil((count + 1) / 3.0);
    CGFloat collectionH =  (rows + 1) * 5.0 + rows * kSizeHeight;
    self.collectionView.frame = CGRectMake(20, 0, kScreenWidth - 20 * 2, collectionH);
}

@end
