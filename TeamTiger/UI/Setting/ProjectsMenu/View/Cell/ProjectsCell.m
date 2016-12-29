//
//  ProjectCell.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProjectsCell.h"

#define kBtnW  40.0
#define kNoDisturbBtnW 40.0
#define kEditViewWidth  (kBtnW * 2 + kNoDisturbBtnW)



@implementation ProjectsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self initSubControls];
    setViewCorner(self.pointImg, 3.0);
    setViewCorner(self.pointImgV, 4.0);
    setViewCorner(self.msgNumBGImgV, 10);
    
    self.addBtn.alpha = 0.0;
    self.deleteBtn.alpha = 0.0;
    self.noDisturbBtn.alpha = 0.0;
    self.isOpenLeft = NO;
    
    self.backgroundColor = [UIColor clearColor];
    self.containerView.backgroundColor = [UIColor clearColor];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadProjectsInfo:(id)object IsLast:(BOOL)isLast{
    if (object && [object isKindOfClass:[TT_Project class]]) {
        TT_Project *project = (TT_Project *)object;
        self.pointImgV.backgroundColor = ColorRGB(arc4random() % 256, arc4random() % 256, arc4random() % 256);
        self.msgNumLab.text = @(arc4random()%99 + 1).stringValue;
        self.projectNameLab.text = project.name;
        self.pointImg.backgroundColor = project.member_type == 1 ? kRGB(45, 202, 205) : kRGB(255, 128, 0);//绿色-我创建的  橙色-我加入的
        UIView *v = [self viewWithTag:2016 + self.tag];
        if (v && [v isKindOfClass:[UIImageView class]]) [v removeFromSuperview];
        if (!isLast) {
            UIImageView *line = [[UIImageView alloc] init];
            line.tag = 2016 + self.tag;
            [self addSubview:line];
            line.backgroundColor = [UIColor darkGrayColor];
            line.alpha = 0.618;
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mas_left).offset(62.0);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom).offset(-minLineWidth);
                make.height.mas_equalTo(minLineWidth);
            }];
        }
        //alpha = 0
        self.addBtn.alpha = 0.0;
        self.deleteBtn.alpha = 0.0;
        self.noDisturbBtn.alpha = 0.0;
        self.arrowImgV.hidden = NO;
        
        self.isOpenLeft = NO;
        
        self.contentView.backgroundColor = self.isOpenLeft ? [UIColor lightGrayColor] : [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        
        
        NSString *addBtnName = project.isTop ? @"icon_top" : @"icon_top-1";
        [self.addBtn setImage:kImage(addBtnName) forState:UIControlStateNormal];
        
        self.msgNumLab.hidden = project.isNoDisturb;
        self.msgNumBGImgV.hidden = project.isNoDisturb;
        
        self.notdisturbImgV.hidden = project.isNoDisturb ? NO : YES;
        NSString *noDisturbBtnName = project.isNoDisturb ? @"icon_do_not_disturb-1" : @"icon_do_not_disturb";
        [self.noDisturbBtn setImage:kImage(noDisturbBtnName) forState:UIControlStateNormal];
        
        
    
        
    }
}


//初始化子控件
- (void)initSubControls{
    //绑定删除会员事件
    [self.deleteBtn addTarget:self action:@selector(deleteMember:) forControlEvents:UIControlEventTouchUpInside];
    
    //绑定增加会员事件
    [self.addBtn addTarget:self action:@selector(addMember:) forControlEvents:UIControlEventTouchUpInside];
    
    //免打扰
    [self.noDisturbBtn addTarget:self action:@selector(noDisturbBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    //3、给容器containerView绑定左右滑动清扫手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft; //设置向左清扫
    [self.containerView addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;//设置向右清扫
    [self.containerView addGestureRecognizer:rightSwipe];
    self.rightSwipe = rightSwipe;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone; //设置单元格选中样式
}

//子控件布局
- (void)layoutSubviews{
    self.noDisturbBtn.frame = CGRectMake(Screen_Width - kBtnW * 2 - kNoDisturbBtnW, 0, kNoDisturbBtnW, CELLHEIGHT);
    
    self.addBtn.frame = CGRectMake(Screen_Width - kBtnW * 2, 0, kBtnW, CELLHEIGHT);
    
    self.deleteBtn.frame = CGRectMake(Screen_Width - kBtnW, 0, kBtnW, CELLHEIGHT);
    
    self.containerView.frame = self.contentView.bounds;
}


//删除会员
- (void)deleteMember:(UIButton *)sender{
    //如果实现了删除block回调，则调用block
    if (self.deleteMember)
        self.deleteMember();
}

//增加会员
- (void)addMember:(UIButton *)sender {
    if (self.addMember)
        self.addMember();
}

//消息免打扰
- (void)noDisturbBtn:(UIButton *)sender {
    if (self.noDisturbBlokc) {
        self.noDisturbBlokc();
    }
}

//左滑动和右滑动手势
- (void)swipe: (UISwipeGestureRecognizer *)sender
{
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft){
        if (self.isOpenLeft) return; //已经打开左滑，不再执行
        self.contentView.backgroundColor = [Common colorFromHexRGB:@"1f2c3e"];
        [self.contentView sendSubviewToBack:self.containerView];
        //开始左滑： 先调用block关闭其他可能左滑的cell
        if (self.closeOtherCellSwipe)
            self.closeOtherCellSwipe();
        
        [UIView animateWithDuration:0.5 animations:^{
            self.arrowImgV.hidden = YES;
            self.msgNumLab.hidden = YES;
            self.msgNumBGImgV.hidden = YES;
        } completion:^(BOOL finished) {
            if (finished) {
                self.addBtn.alpha = 1.0;
                self.deleteBtn.alpha = 1.0;
                self.noDisturbBtn.alpha = 1.0;
            }
        }];
        
        self.isOpenLeft = YES;
    }
    else if (sender.direction == UISwipeGestureRecognizerDirectionRight){
        self.contentView.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
        [self closeLeftSwipe]; //关闭左滑
    }
}

//关闭左滑，恢复原状
- (void)closeLeftSwipe{
    if (!self.isOpenLeft) return; //还未打开左滑，不需要执行右滑
    self.contentView.backgroundColor = [UIColor colorWithRed:21.0/255.0f green:27.0/255.0f blue:38.0/255.0f alpha:1.0f];
    [UIView animateWithDuration:0.5 animations:^{
        self.arrowImgV.hidden = NO;
        self.msgNumLab.hidden = NO;
        self.msgNumBGImgV.hidden = NO;
    } completion:^(BOOL finished) {
        if (finished) {
            self.addBtn.alpha = 0.0;
            self.deleteBtn.alpha = 0.0;
            self.noDisturbBtn.alpha = 0.0;
        }
    }];
    
    self.isOpenLeft = NO;
}

@end
