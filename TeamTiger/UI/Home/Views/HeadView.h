//
//  HeadView.h
//  TeamTiger
//
//  Created by Dale on 16/8/10.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeadView;

@protocol HeadViewDelegate <NSObject>

- (void)headViewDidClickWithHeadView:(HeadView *)headView;

@end

@interface HeadView : UITableViewHeaderFooterView

@property (weak, nonatomic) IBOutlet UILabel *numberLB;
+ (instancetype)headerViewWithTableView:(UITableView *)tableView;
@property (assign, nonatomic) id <HeadViewDelegate> delegate;

@end
