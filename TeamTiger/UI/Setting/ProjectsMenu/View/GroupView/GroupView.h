//
//  GroupView.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GroupView;

typedef void(^ClickBtnBlock)(GroupView *gView, BOOL isConfirm, id object);

@interface GroupView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UIButton *confirmBtn;

@property(nonatomic,weak)IBOutlet UIButton *cancelBtn;

@property(nonatomic,weak)IBOutlet UITextField *nameTxtField;

@property(nonatomic,weak)IBOutlet UITableView *table;

@property(nonatomic,strong)NSMutableArray *projects;

@property(nonatomic,strong)NSMutableArray *selProjects;

@property(nonatomic,strong)NSMutableDictionary *groupInfo;

@property(nonatomic,copy)ClickBtnBlock clickBtnBlock;

@property(nonatomic,assign)BOOL isShow;

- (void)loadGroupInfo:(id)groupInfo AllProjects:(NSArray *)projects;

- (void)show;

- (void)hide;

@end
