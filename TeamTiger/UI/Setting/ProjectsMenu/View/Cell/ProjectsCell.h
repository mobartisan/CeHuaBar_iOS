//
//  ProjectCell.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"

#define CELLHEIGHT  60.0

@interface ProjectsCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UIImageView *pointImg;

@property (weak, nonatomic) IBOutlet UIImageView *iconNewImg;

@property(nonatomic, weak) IBOutlet UIImageView *arrowImgV;

@property(nonatomic, weak) IBOutlet UIImageView *pointImgV;

@property(nonatomic, weak) IBOutlet UILabel *projectNameLab;

@property (weak, nonatomic) IBOutlet UIImageView *notdisturbImgV;

@property(nonatomic, weak) IBOutlet UILabel *msgNumLab;

@property(nonatomic, weak) IBOutlet UIImageView *msgNumBGImgV;

@property(nonatomic, weak) IBOutlet NSLayoutConstraint *trailingConstrait;

@property (strong, nonatomic) TT_Project *project;

- (void)loadProjectsInfo:(id)object IsLast:(BOOL)isLast;

@end
