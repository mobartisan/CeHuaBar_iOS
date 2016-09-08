//
//  ProfileCell.h
//  TeamTiger
//
//  Created by xxcao on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

#define itemSize  (Screen_Width / 4.0)

@class ProjectCell;

typedef enum : NSUInteger {
    EProjectSelect = 0,
    EProjectGroup,
    EProjectAddMember,
    EProjectDleteProject,
} EProjectType;

typedef void(^ClickActionBlock)(ProjectCell *cell, int type);

@interface ProjectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *bgImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UITextField *detailTxtField;
@property (weak, nonatomic) IBOutlet UIImageView *accessoryImgV;
@property (weak, nonatomic) IBOutlet UIButton *exitBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (copy, nonatomic) ClickActionBlock block;


+ (instancetype)loadCellWithType:(int)type;

+ (CGFloat)loadCellHeightWithData:(id)obj;

- (void)reloadCellData:(id)obj;

- (IBAction)clickExitBtnAction:(id)sender;


@end
