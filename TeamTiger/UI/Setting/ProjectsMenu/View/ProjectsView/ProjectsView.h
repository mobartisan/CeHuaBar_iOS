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


@interface ProjectsView : UIView

@property(strong, nonatomic) ClickAddProjectBlock addProjectBlock;

@property(strong, nonatomic) ClickProjectBlock projectBlock;

- (instancetype)initWithDatas:(NSArray *)datas;

- (void)loadProjectsInfos:(NSArray *)projects;

+ (CGFloat)heightOfProjectsView:(NSArray *)projects;


@end