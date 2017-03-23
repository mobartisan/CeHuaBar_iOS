//
//  VoteView.h
//  TeamTiger
//
//  Created by Dale on 16/11/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VoteModel;
typedef void(^VoteClickBlock)(VoteModel *voteModel);

@interface VoteView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) VoteClickBlock voteClickBlock;

@end


@interface VoteBottomView : UIView

@property (strong, nonatomic) NSArray *ticketArr;
@property (assign, nonatomic) CGFloat total_count;

@end
