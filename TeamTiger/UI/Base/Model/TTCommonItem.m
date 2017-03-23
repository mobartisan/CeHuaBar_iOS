//
//  TTCommonItem.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonItem.h"

@implementation TTCommonItem

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title
{
    TTCommonItem *item = [[self alloc] init];
    item.icon = icon;
    item.title = title;
    return item;
}


+ (instancetype)itemWithTitle:(NSString *)title
{
    return [self itemWithIcon:nil title:title];
}
@end
