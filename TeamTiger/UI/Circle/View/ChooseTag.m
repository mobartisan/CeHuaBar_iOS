//
//  ChooseTag.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ChooseTag.h"
#import "ChooseTagCell.h"

static NSString *cellID = @"ChooseTagCell";

@interface ChooseTag()<UICollectionViewDataSource, UICollectionViewDelegate>
//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILabel *titleLB;
@property (strong, nonatomic) UIView *divider;
@end
@implementation ChooseTag

- (instancetype)init
{
    if (self = [super init]) {

        [self addSubview:self.titleLB];
        [self addSubview:self.collectionView];
        [self addSubview:self.divider];
    }
    return self;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] init];
        _titleLB.text = @"我的分组:";
        _titleLB.textColor = [UIColor whiteColor];
        _titleLB.font = FONT(15);
    }
    return _titleLB;
}

- (UIView *)divider {
    if (!_divider) {
        UIView *divider = [[UIView alloc] init];
        divider.backgroundColor = [UIColor blackColor];
        divider.alpha = 0.2;
        _divider = divider;
    }
    return _divider;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
        //        [layOut setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.hyb_width, self.hyb_height) collectionViewLayout:layOut];
        _collectionView.pagingEnabled = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        //        [_collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
        _collectionView.backgroundColor = [UIColor clearColor];
    }
    return _collectionView;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self).offset(kDistanceToHSide);
        make.height.mas_equalTo(kLabelHeight);
        make.width.mas_equalTo(200);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLB.mas_bottom).offset(kDistanceToVSide);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(self);
    }];
    
    [self.divider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self).offset(-1);
    }];
    // 注册cell
    //    [self.collectionView registerNib:[UINib nibWithNibName:cellID bundle:nil] forCellWithReuseIdentifier:cellID];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.tags.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.tags[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
//    AttentsModel *attends = (AttentsModel *)self.attends[indexPath.item];
//    cell.meetingAttendsClick = ^(AttentsModel *attends){
//        if (wSelf.attendsViewCellClick) {
//            wSelf.attendsViewCellClick(attends);
//        }
//    };
//    if (indexPath.item == 0) {
//        attends.isMaster = YES;
//    } else
//        attends.isMaster = NO;
//    cell.attents = attends;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (is40inch || is35inch) {
        return CGSizeMake(40, 40);
    }
    return CGSizeMake(50, 50);
    
    //    return CGSizeMake(50, self.cellHeight);
}


//设置每组的cell的边界
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    if (section % 2 == 0) {
        return UIEdgeInsetsMake(0, 16, 0, 16);
    } else
        return UIEdgeInsetsMake(0, 50, 0, 50);
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (is40inch || is35inch) {
        return 10;
    }
    return 20;
}


@end
