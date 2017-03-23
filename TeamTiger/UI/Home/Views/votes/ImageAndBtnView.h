//
//  ImageAndBtnView.h
//  TeamTiger
//
//  Created by Dale on 16/11/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageAndBtnView : UIView

@property (strong, nonatomic)  UIImageView *imageV;
@property (strong, nonatomic)  UILabel *projectLB;
@property (strong, nonatomic)  ButtonIndexPath *voteBtn;

@end

@interface ProgresssAndTicketView : UIView


@property (strong, nonatomic) UILabel *aLB;
@property (strong, nonatomic) UIProgressView *aProgressView;
@property (strong, nonatomic) UILabel *aTicket;


@end
