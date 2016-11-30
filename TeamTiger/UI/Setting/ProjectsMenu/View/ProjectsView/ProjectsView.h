//
//  ProjectsView.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectsView;

typedef void(^ClickProjectBlock)(ProjectsView *projectV, id projectObj);

typedef void(^ClickAddProjectBlock)(ProjectsView *projectV);

typedef void(^LongPressProjectBlock)(ProjectsView *projectV, id projectObj);

@interface ProjectsView : UIView

@property(strong, nonatomic) ClickAddProjectBlock addProjectBlock;

@property(strong, nonatomic) ClickProjectBlock projectBlock;

@property(strong, nonatomic) LongPressProjectBlock longPressBlock;

- (instancetype)initWithDatas:(NSArray *)datas;

- (void)loadGroupsInfos:(NSArray *)groups;

+ (CGFloat)heightOfProjectsView:(NSArray *)projects;


@end
