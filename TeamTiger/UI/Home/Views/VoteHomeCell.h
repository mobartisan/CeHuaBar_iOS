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

@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLB;
@property (weak, nonatomic) IBOutlet UILabel *typeLB;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;
@property (weak, nonatomic) IBOutlet UIImageView *image3;
@property (weak, nonatomic) IBOutlet UILabel *aDesLB;
@property (weak, nonatomic) IBOutlet UILabel *bDesLB;
@property (weak, nonatomic) IBOutlet UILabel *cDesLB;
@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;
@property (weak, nonatomic) IBOutlet UIButton *cBtn;
@property (weak, nonatomic) IBOutlet UIProgressView *aProgress;
@property (weak, nonatomic) IBOutlet UILabel *aTicketLB;
@property (weak, nonatomic) IBOutlet UILabel *aPerLB;
@property (weak, nonatomic) IBOutlet UIProgressView *bProgress;
@property (weak, nonatomic) IBOutlet UILabel *bTicketLB;
@property (weak, nonatomic) IBOutlet UILabel *bPerLB;
@property (weak, nonatomic) IBOutlet UIProgressView *cProgress;
@property (weak, nonatomic) IBOutlet UILabel *cTicketLB;
@property (weak, nonatomic) IBOutlet UILabel *cPerLB;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet ButtonIndexPath *moreBtn;

@property (copy, nonatomic) ClickBtn clickBtn;
@property (strong, nonatomic) HomeCellModel *model;

@property (assign, nonatomic) id <VoteHomeCellDelegate> delegate;

+ (CGFloat)tableViewHeight;

@end
