//
//  GroupCollectionViewCell.h
//  TeamTiger
//
//  Created by Dale on 16/12/26.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define  kSizeWidth   ((Screen_Width - 50) / 3.0)
#define  kSizeHeight   75.0

@interface GroupCollectionViewCell : UICollectionViewCell


@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) TT_Group *group;
@property (nonatomic,assign) NSUInteger count;

@property (copy, nonatomic) void(^clickAddGroupBlock)();//添加分组
@property (copy, nonatomic) void(^clickGroupBlock)(TT_Group *group);//点击进入moments
@property (copy, nonatomic) void(^longPressItemBlock)();//长按删除
@property (copy, nonatomic) void (^clickDeleteBtnBlock)(TT_Group *group);//删除按钮

@end
