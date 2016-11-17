//
//  HomeCommentCell.h
//  BBSDemo
//
//  Created by Dale on 16/10/31.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeCommentModelFrame;

@protocol HomeCommentCellDelegate <NSObject>

@optional
- (void)clickMoreBtn;
@end

@interface HomeCommentCell : UITableViewCell

@property (strong, nonatomic) HomeCommentModelFrame *modelFrame;
@property (assign, nonatomic) id<HomeCommentCellDelegate> delegate;
@property (strong, nonatomic) UIView *lineView1;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

