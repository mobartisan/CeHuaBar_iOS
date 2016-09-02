//
//  VoteHomeCell.h
//  TeamTiger
//
//  Created by Dale on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeCellModel, ButtonIndexPath;
typedef void(^ClickBtn)(UIButton *button);

@protocol VoteHomeCellDelegate <NSObject>
- (void)reloadTableViewWithHeight:(CGFloat)height withIndexPath:(NSIndexPath *)indexPath;
@end

@interface VoteHomeCell : UITableViewCell<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;
@property (weak, nonatomic) IBOutlet UIButton *cBtn;
@property (weak, nonatomic) IBOutlet ButtonIndexPath *moreBtn;

@property (copy, nonatomic) ClickBtn clickBtn;
@property (copy, nonatomic) void(^voteClick)();
@property (strong, nonatomic) HomeCellModel *model;

@property (assign, nonatomic) id <VoteHomeCellDelegate> delegate;

+ (CGFloat)tableViewHeight;
+ (CGFloat)cellHeightWithModel:(HomeCellModel *)model;

@end
