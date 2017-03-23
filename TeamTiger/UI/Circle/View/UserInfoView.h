//
//  UserInfoView.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoView;

typedef void(^ClickHeadBtnBlock)(UserInfoView *view);

@interface UserInfoView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *offerLab;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

@property (copy, nonatomic) ClickHeadBtnBlock clickBlock;

- (void)userInfoViewWithData:(id) dataSource;

@end
