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
#define kAddProjectBtnW    30.0

@implementation GroupHeadView

- (UIButton *)addProjectBtn {
    if (_addProjectBtn == nil) {
        _addProjectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addProjectBtn setTitle:@"添加项目" forState:UIControlStateNormal];
        _addProjectBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addProjectBtn setTitleColor:kRGB(68, 102, 149) forState:UIControlStateNormal];
        [_addProjectBtn setImage:kImage(@"add") forState:UIControlStateNormal];
        [_addProjectBtn addTarget:self action:@selector(handleAddProjectAction) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_addProjectBtn];
    }
    return _addProjectBtn;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubControls];
}

- (void)loadHeadViewData:(id)object {
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        self.groupNameLab.text = object[@"Name"];
        self.messageNumLab.text = [NSString stringWithFormat:@"查看(%d)",arc4random()% 99 + 1];
        self.messageNumLab.hidden = YES;
    }
}

- (void)loadHeadViewIndex:(NSInteger)index projectCount:(NSUInteger)projectCount {
    self.messageNumLab.hidden = YES;
    if (index == 1) {
        self.addProjectBtn.hidden = YES;
        self.groupNameLab.text = @"我的分组";
        self.backgroundColor = [UIColor clearColor];
        self.containerView.backgroundColor = [UIColor clearColor];
    } else if (index == 2) {
        self.addProjectBtn.hidden = NO;
        self.groupNameLab.text = [NSString stringWithFormat:@"所有项目(%tu个)", projectCount];
        self.backgroundColor = [Common colorFromHexRGB:@"1c293b"];
        self.containerView.backgroundColor = [Common colorFromHexRGB:@"1c293b"];
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
    [self.addProjectBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -self.addProjectBtn.imageView.size.width, 0, self.addProjectBtn.imageView.size.width)];
    [self.addProjectBtn setImageEdgeInsets:UIEdgeInsetsMake(0, self.addProjectBtn.titleLabel.bounds.size.width, 0, -self.addProjectBtn.titleLabel.bounds.size.width - 5)];
    self.addProjectBtn.frame = CGRectMake(Screen_Width - 100, 10, 90, 20);
    self.deleteView.frame = CGRectMake(Screen_Width - 120, 0, 120, kViewHeight);
    self.containerView.frame = self.bounds;
}

//添加项目
- (void)handleAddProjectAction {
    if (self.addProjectBlock) {
        self.addProjectBlock();
    }
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
