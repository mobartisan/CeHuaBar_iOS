//
//  GroupHeadView.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHeadView : UIView

@property(nonatomic, weak)  IBOutlet UILabel *groupNameLab;

@property(nonatomic, weak)  IBOutlet UILabel *messageNumLab;

@property (nonatomic, weak) IBOutlet UIView *containerView; //容器view

@property (nonatomic, weak) IBOutlet UIView *deleteView; //底层删除按钮

@property (nonatomic, weak) IBOutlet UIButton *deleteBtn; //底层删除按钮

@property (nonatomic, weak) IBOutlet UIButton *editBtn; //底层删除按钮

@property (strong, nonatomic) UIButton *addProjectBtn;//创建项目按钮

@property (nonatomic, assign) BOOL isOpenLeft; //是否已经打开左滑动

@property (nonatomic, assign) BOOL isEnabledSwipe; //是否允许左滑动

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe; //向右清扫手势

@property (nonatomic, copy) void (^deleteGroup)();
@property (nonatomic, copy) void (^editGroup)();
@property (copy, nonatomic) void (^addProjectBlock)();
@property (nonatomic, copy) void (^closeOtherCellSwipe)(); //关闭其他cell的左滑

- (void)closeLeftSwipe; //关闭左滑

- (void)loadHeadViewData:(id)object;//from data

- (void)loadHeadViewIndex:(NSInteger)index projectCount:(NSUInteger)projectCount;//from index

@end
