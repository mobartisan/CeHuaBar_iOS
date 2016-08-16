//
//  CirclesItemCell.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclesItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pointImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UIImageView *divider;
@property (nonatomic, assign, getter = isLastRowInSection) BOOL lastRowInSection;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

-(void)setData:(id)item;

@end
