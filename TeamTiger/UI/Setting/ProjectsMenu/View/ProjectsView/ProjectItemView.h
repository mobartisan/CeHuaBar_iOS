//
//  ProjectItemView.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProjectItemView;

typedef void(^ClickProjectItemBlock)(ProjectItemView *projectV, id object);

typedef void(^ClickAddProjectItemBlock)(ProjectItemView *projectV);

typedef void(^LongPressItemBlock)(ProjectItemView *projectV, id object);

@interface ProjectItemView : UIView

@property(nonatomic, copy)ClickProjectItemBlock clickProjectItemBlock;

@property(nonatomic, copy)ClickAddProjectItemBlock clickAddProjectItemBlock;

@property(nonatomic, copy)LongPressItemBlock longPressItemBlock;

- (instancetype)initWithData:(id)object ;

@end
