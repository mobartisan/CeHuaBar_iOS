//
//  VoteModel.h
//  TeamTiger
//
//  Created by Dale on 16/12/15.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VoteModel : NSObject

@property (copy, nonatomic) NSString *_id;
@property (copy, nonatomic) NSString *url;
@property (assign, nonatomic) BOOL isvote;
@property (copy, nonatomic) NSString *vote_name;
@property (assign, nonatomic) CGFloat count;

@end
