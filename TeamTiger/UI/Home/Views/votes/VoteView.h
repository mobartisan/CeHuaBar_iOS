//
//  VoteView.h
//  TeamTiger
//
//  Created by Dale on 16/11/8.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoteView : UIView

@property (nonatomic, strong) NSArray *picPathStringsArray;
@property (copy, nonatomic) NSString *content;

@end


@interface VoteBottomView : UIView

@property (strong, nonatomic) NSArray *ticketArr;

@end
