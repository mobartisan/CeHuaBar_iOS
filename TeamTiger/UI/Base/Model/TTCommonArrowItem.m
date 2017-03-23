//
//  TTCommonArrowItem.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonArrowItem.h"

@implementation TTCommonArrowItem
+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass
{
    TTCommonArrowItem *item = [self itemWithIcon:icon title:title];
    item.subtitle = subtitle;
    item.destVcClass = destVcClass;
    return item;
}

+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass
{
    return [self itemWithIcon:nil title:title subtitle:subtitle destVcClass:destVcClass];
}
@end
