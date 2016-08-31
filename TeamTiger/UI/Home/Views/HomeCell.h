//
//  HomeCell.h
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickCommentBtn)(UIButton *button);

@class HomeCellModel, ButtonIndexPath;

@protocol HomeCellDelegate <NSObject>

- (void)reloadHomeTableView:(NSIndexPath *)indexPath;

@end

@interface HomeCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ButtonIndexPath *moreBtn;
@property (assign, nonatomic) id <HomeCellDelegate> delegate;
@property (strong, nonatomic) HomeCellModel *model;
@property (copy, nonatomic)   ClickCommentBtn clickCommentBtn;

+ (CGFloat)tableViewHeight;
+ (CGFloat)cellHeightWithModel:(HomeCellModel *)model;
+ (instancetype)homeCellWithTableView:(UITableView *)tableView model:(HomeCellModel *)model;

@end
