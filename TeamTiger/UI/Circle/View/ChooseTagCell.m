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

}

- (void)layoutSubviews {
    [super layoutSubviews];
//    if (is40inch || is35inch) {
//        self.tagBtn.layer.cornerRadius = 40 * 0.5;
//    }
    self.tagBtn.layer.cornerRadius = self.hyb_width * 0.5;
}

@end
