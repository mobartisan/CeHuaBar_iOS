//
//  AddImageView.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AddImageViewDefual = 0,
    AddImageViewVote,
    AddImageViewVoteWithTitle,
} AddImageViewType;

@interface AddImageView : UIView

@property(nonatomic, copy)NSString *optionStr;

+ (instancetype)addImageViewWithType:(AddImageViewType)type AndOption:(NSString *)option;

+ (instancetype)addImageView;
@end
