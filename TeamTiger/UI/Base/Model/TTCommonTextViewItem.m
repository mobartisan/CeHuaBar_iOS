//
//  TTCommonTextViewItem.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonTextViewItem.h"

@implementation TTCommonTextViewItem
+ (instancetype)itemWithTitle:(NSString *)title textViewPlaceholder:(NSString *)placeholder{
    TTCommonTextViewItem *item = [self itemWithIcon:nil title:title];
    item.placeholder = placeholder;
    return item;
}
@end
