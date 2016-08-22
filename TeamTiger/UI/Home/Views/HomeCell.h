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

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet ButtonIndexPath *moreBtn;
@property (assign, nonatomic) id <HomeCellDelegate> delegate;

@property (strong, nonatomic) HomeCellModel *model;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (copy, nonatomic)   ClickCommentBtn clickCommentBtn;

+ (CGFloat)tableViewHeight;

@end
