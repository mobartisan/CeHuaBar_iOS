//
//  GroupHeadView.m
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "GroupHeadView.h"

@implementation GroupHeadView

- (void)loadHeadViewData:(id)object {
    if (object && [object isKindOfClass:[NSDictionary class]]) {
        self.groupNameLab.text = object[@"Name"];
        self.messageNumLab.text = [NSString stringWithFormat:@"查看(%d)",arc4random()% 99 + 1];
    }
}

@end
