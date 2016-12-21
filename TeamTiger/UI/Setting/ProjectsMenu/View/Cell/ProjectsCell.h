//
//  ProjectCell.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELLHEIGHT  53.0

@interface ProjectsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pointImg;

@property(nonatomic, weak) IBOutlet UIImageView *arrowImgV;

@property(nonatomic, weak) IBOutlet UIImageView *pointImgV;

@property(nonatomic, weak) IBOutlet UILabel *projectNameLab;

@property (weak, nonatomic) IBOutlet UIImageView *notdisturbImgV;

@property(nonatomic, weak) IBOutlet UILabel *msgNumLab;

@property(nonatomic, weak) IBOutlet UIImageView *msgNumBGImgV;

@property (nonatomic, weak) IBOutlet UIView *containerView; //容器view

@property (nonatomic, weak) IBOutlet UIButton *deleteBtn; //底层删除按钮

@property (nonatomic, weak) IBOutlet UIButton *addBtn; //底层置顶按钮

@property (weak, nonatomic) IBOutlet UIButton *noDisturbBtn;

@property (nonatomic, assign) BOOL isOpenLeft; //是否已经打开左滑动

@property (nonatomic, strong) UISwipeGestureRecognizer *rightSwipe; //向右清扫手势

@property (nonatomic, copy) void (^deleteMember)(); //删除会员block回调方法

@property (nonatomic, copy) void (^addMember)(); //增加会员block回调方法

@property (copy, nonatomic) void (^noDisturbBlokc)();//免打扰

@property (nonatomic, copy) void (^closeOtherCellSwipe)(); //关闭其他cell的左滑

- (void)closeLeftSwipe; //关闭左滑

- (void)loadProjectsInfo:(id)object IsLast:(BOOL)isLast;

@end
