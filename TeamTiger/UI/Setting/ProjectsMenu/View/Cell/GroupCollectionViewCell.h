//
//  GroupCollectionViewCell.h
//  TeamTiger
//
//  Created by Dale on 16/12/26.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupCollectionViewCell : UICollectionViewCell

@property(nonatomic,strong) UIButton *addBtn;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (strong, nonatomic) NSIndexPath *indexPath;
- (void)configureCellWithGroup:(TT_Group *)group ;

@property (copy, nonatomic) void(^clickAddGroupBlock)();//添加分组
@property (copy, nonatomic) void(^clickGroupBlock)();//点击进入moments
@property (copy, nonatomic) void(^longPressItemBlock)();//长按删除
@property (copy, nonatomic) void (^clickDeleteBtnBlock)(NSIndexPath *indexPath);//删除按钮

@end
