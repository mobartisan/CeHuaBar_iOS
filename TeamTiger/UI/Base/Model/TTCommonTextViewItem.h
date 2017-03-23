//
//  TTCommonTextViewItem.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonItem.h"

@interface TTCommonTextViewItem : TTCommonItem
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *text;
+ (instancetype)itemWithTitle:(NSString *)title textViewPlaceholder:(NSString *)placeholder;
@end
