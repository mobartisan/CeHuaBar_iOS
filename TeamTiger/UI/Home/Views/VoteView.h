//
//  VoteView.h
//  TeamTiger
//
//  Created by Dale on 16/11/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteView : UIView

//是否是commentCell类型
@property (assign, nonatomic) BOOL isCommentCell;

@property (nonatomic, strong) NSArray *picPathStringsArray;

@end
