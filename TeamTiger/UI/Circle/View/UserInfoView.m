//
//  UserInfoView.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/2.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "UserInfoView.h"
#import "UIControl+YYAdd.h"

@implementation UserInfoView


- (void)userInfoViewWithData:(id) dataSource {

}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImgV.layer.masksToBounds = YES;
    self.headImgV.layer.cornerRadius = self.headImgV.hyb_height * 0.5;
    self.headImgV.backgroundColor = [UIColor clearColor];
    self.headImgV.image = kImageForHead;
}

- (IBAction)clickBtnAction:(id)sender {
    if (self.clickBlock) {
        self.clickBlock(self);
    }
}

@end
