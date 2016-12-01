//
//  DeleteFooterView.m
//  TeamTiger
//
//  Created by xxcao on 2016/12/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "DeleteFooterView.h"

@implementation DeleteFooterView

- (void)awakeFromNib {
    [super awakeFromNib];
    setViewCorner(self.deleteBtn, 6);
}

- (IBAction)deleteBtnAction:(id)sender {
    if (self.deleteGroupBlock) {
        self.deleteGroupBlock(self);
    }
}

@end
