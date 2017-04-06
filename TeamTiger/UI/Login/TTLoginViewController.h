//
//  TTLoginViewController.h
//  TeamTiger
//
//  Created by xxcao on 16/8/4.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTBaseViewController.h"

@interface TTLoginViewController : TTBaseViewController

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIImageView *loginBgImgV;

@property (weak, nonatomic) IBOutlet UILabel *versionLab;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@end
