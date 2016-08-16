//
//  ChooseTagCell.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/16.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "ChooseTagCell.h"

@implementation ChooseTagCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.tagBtn.layer.masksToBounds = YES;
    self.tagBtn.layer.cornerRadius = self.tagBtn.hyb_height * 0.5;

}

@end
