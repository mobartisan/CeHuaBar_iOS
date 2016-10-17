//
//  GroupHeadView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupHeadView.h"

#define kViewHeight     60.0
#define kEditViewWidth  110.0

@implementation GroupHeadView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubControls];
}

- (void)loadHeadViewData:(id)object {
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        self.groupNameLab.text = object[@"Name"];
        self.messageNumLab.text = [NSString stringWithFormat:@"查看(%d)",arc4random()% 99 + 1];
    }
}


//初始化子控件
- (void)initSubControls{    
    //3、给容器containerView绑定左右滑动清扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft; //设置向左清扫
    [self.containerView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;//设置向右清扫
    [self.containerView addGestureRecognizer:rightSwipe];
    self.rightSwipe = rightSwipe;
}

//子控件布局
- (void)layoutSubviews{
    self.deleteView.frame = CGRectMake(Screen_Width - kEditViewWidth, 0, kEditViewWidth, kViewHeight);
    self.containerView.frame = self.bounds;
}


//删除会员
- (IBAction)deleteGroup: (UIButton *)sender{
    if (self.deleteGroup) {
        self.deleteGroup();
    }
}

//删除会员
- (IBAction)editGroup: (UIButton *)sender{
    if (self.editGroup) {
        self.editGroup();
    }
}


//左滑动和右滑动手势
- (void)swipe: (UISwipeGestureRecognizer *)sender {
    if(!self.isEnabledSwipe) return;
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        if (self.isOpenLeft) return; //已经打开左滑，不再执行
        //开始左滑： 先调用block关闭其他可能左滑的cell
        if (self.closeOtherCellSwipe)
            self.closeOtherCellSwipe();
        
        [UIView animateWithDuration:0.5 animations:^{
            sender.view.center = CGPointMake(Screen_Width * 0.5 - kEditViewWidth, kViewHeight * 0.5);
        }];
        self.isOpenLeft = YES;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        [self closeLeftSwipe]; //关闭左滑
    }
}

//关闭左滑，恢复原状
- (void)closeLeftSwipe{
    if (!self.isOpenLeft) return; //还未打开左滑，不需要执行右滑
    
    [UIView animateWithDuration:0.5 animations:^{
        self.containerView.center = CGPointMake(Screen_Width * 0.5, kViewHeight * 0.5);
    }];
    self.isOpenLeft = NO;
}

@end
