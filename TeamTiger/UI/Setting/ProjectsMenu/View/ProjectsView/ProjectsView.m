//
//  ProjectsView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ProjectsView.h"
#import "ProjectItemView.h"
#import "YTAnimation.h"

#define  kSizeWidth   ((Screen_Width - 50) / 3.0)
#define  kSizeHeight   75.0

@interface ProjectsView ()

@property(nonatomic, strong)UIScrollView *scrollView;



@end

@implementation ProjectsView

- (instancetype)initWithDatas:(NSArray *)datas {
    self = [super init];
    if (self) {
        [self initScrollViewWithDats:datas IsInit:YES];
    }
    return self;
}

- (void)loadGroupsInfos:(NSArray *)groups {
    [self initScrollViewWithDats:groups IsInit:NO];
}

+ (CGFloat)heightOfProjectsView:(NSArray *)projects {
    NSInteger count = projects.count;
    NSInteger rows = ceil((count + 1) / 3.0);
    return (rows + 1) * 5.0 + rows * kSizeHeight;
}

#pragma -mark
- (void)initScrollViewWithDats:(NSArray *)datas IsInit:(BOOL)isInit {
    if (isInit) {
        //scrollview
        self.scrollView = [[UIScrollView alloc] init];
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        //contentview
        self.contentView = [[UIView alloc] init];
        [self.scrollView addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.scrollView);
            make.width.equalTo(self.scrollView);
        }];
    } else {
        //scrollview
        for (NSInteger i = self.scrollView.subviews.count - 1; i >= 0; i--) {
            UIView *v = self.scrollView.subviews[i];
            if (v && [v isKindOfClass:[ProjectItemView class]]) {
                [v removeFromSuperview];
            }
        }
    }
    [[CirclesManager sharedInstance].views removeAllObjects];
    __block UIView *lastView1 = nil, *lastView2 = nil, *lastView3 = nil;
    NSUInteger count = datas.count;
    for (int i = 0; i < count + 1; i++) {
        ProjectItemView *tmpView = [[ProjectItemView alloc] initWithData:(i == count ? nil : datas[i])];
        [self.scrollView addSubview:tmpView];
        [tmpView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(kSizeWidth));
            make.height.equalTo(@(kSizeHeight));
            make.left.mas_equalTo(20 + (kSizeWidth + 5) * (i % 3));
            if (i % 3 == 0) {
                if (lastView1){
                    make.top.mas_equalTo(lastView1.mas_bottom).offset(5.0);
                } else {
                    make.top.mas_equalTo(self.contentView.mas_top).offset(5.0);
                }
                lastView1 = tmpView;
            }
            else if (i % 3 == 1) {
                if (lastView2){
                    make.top.mas_equalTo(lastView2.mas_bottom).offset(5.0);
                } else {
                    make.top.mas_equalTo(self.contentView.mas_top).offset(5.0);
                }
                lastView2 = tmpView;
            }
            else if (i % 3 == 2) {
                if (lastView3){
                    make.top.mas_equalTo(lastView3.mas_bottom).offset(5.0);
                } else {
                    make.top.mas_equalTo(self.contentView.mas_top).offset(5.0);
                }
                lastView3 = tmpView;
            }
            
            
        }];
        if (!isInit) {
            if (i < count) {
                [[CirclesManager sharedInstance].views addObject:tmpView];
            }
        }
        WeakSelf;
        //data handle
        tmpView.clickProjectItemBlock = ^(ProjectItemView *itemView,id object){
            if (self.projectBlock) {
                self.projectBlock(self,object);
            }
        };
        tmpView.clickAddProjectItemBlock = ^(ProjectItemView *itemView){
            if (self.addProjectBlock) {
                self.addProjectBlock(self);
            }
        };
        tmpView.longPressItemBlock = ^(ProjectItemView *itemView,id object){
            if (wself.longPressBlock) {
                wself.longPressBlock(wself.contentView,object);
            }
        };
    }
    [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(lastView1.mas_bottom);
    }];
    
}

- (void)vibrateAnimation:(UIView *)animationView {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.rotation";
    CGFloat angle = M_PI_4/15;
    animation.values = @[@(-angle),@(angle),@(-angle)];
    animation.repeatCount = MAXFLOAT;
    [animationView.layer addAnimation:animation forKey:@"shake"];
}

@end
