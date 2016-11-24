//
//  GroupView.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SelectGroupView;

typedef void(^SelectGroupBlock)(SelectGroupView *sgView, BOOL isConfirm, id object);

@interface SelectGroupView : UIView<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,weak)IBOutlet UIButton *confirmBtn;

@property(nonatomic,weak)IBOutlet UIButton *cancelBtn;

@property(nonatomic,weak)IBOutlet UITableView *table;

@property(nonatomic,strong)NSMutableArray *groups;

@property(nonatomic,strong)NSMutableArray *selGroups;

@property(nonatomic,copy)SelectGroupBlock clickBtnBlock;

@property(nonatomic,assign)BOOL isShow;

- (void)loadGroups:(NSArray *)groups;

- (void)show;

- (void)hide;

@end
