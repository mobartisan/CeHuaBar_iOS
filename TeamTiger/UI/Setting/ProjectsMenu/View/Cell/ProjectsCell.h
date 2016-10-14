//
//  ProjectCell.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProjectsCell : UITableViewCell

@property(nonatomic, weak) IBOutlet UIImageView *pointImgV;

@property(nonatomic, weak) IBOutlet UILabel *projectNameLab;

@property(nonatomic, weak) IBOutlet UILabel *msgNumLab;

@property(nonatomic, weak) IBOutlet UIImageView *msgNumBGImgV;

- (void)loadProjectsInfo:(id)object IsLast:(BOOL)isLast;

@end
