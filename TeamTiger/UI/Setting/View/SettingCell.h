//
//  SettingCell.h
//  TeamTiger
//
//  Created by xxcao on 16/7/28.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ECellType) {
    ECellTypeProjectIcon = 0,
    ECellTypeProjectName,
    ECellTypeAddMember,
    ECellTypeBottom,
    ECellTypeSearch,
    ECellTypeProjectAdd,
};

@class ProjectNameTF, SettingCell, TTFadeSwitch;

typedef void(^NeedActionblock)(SettingCell *settingCell, ECellType type, id obj);

@interface SettingCell : UITableViewCell<UITextViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIButton *createBtn;

@property (strong, nonatomic) UITextView *textView;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UITextField *searchTF;
@property (strong, nonatomic) TTFadeSwitch *tSwitch;
@property (strong, nonatomic) UIImageView *accessoryImgV;
@property (strong, nonatomic) UIImageView *projectIcon;
@property (strong, nonatomic) UIButton *addMemberBtn;
@property (strong, nonatomic) UILabel *selectMemberLabel;
@property (strong, nonatomic) UIButton *addProjectIcon;
@property (copy, nonatomic) NeedActionblock actionBlock;

+ (instancetype)loadCellWithData:(id)data;

- (void)reloadCell:(id)obj;

@end
