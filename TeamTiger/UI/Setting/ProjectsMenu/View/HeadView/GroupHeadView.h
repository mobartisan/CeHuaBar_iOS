//
//  GroupHeadView.h
//  TeamTiger
//
//  Created by xxcao on 2016/10/14.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupHeadView : UIView

@property(nonatomic,weak)IBOutlet UILabel *groupNameLab;

@property(nonatomic,weak)IBOutlet UILabel *messageNumLab;

- (void)loadHeadViewData:(id)object;

@end
