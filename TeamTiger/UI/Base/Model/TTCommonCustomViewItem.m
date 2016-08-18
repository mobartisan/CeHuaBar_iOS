//
//  TTCommonCustomViewItem.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonCustomViewItem.h"

@implementation TTCommonCustomViewItem
+ (instancetype)itemWithCustomView:(UIView *)customView {
    TTCommonCustomViewItem *item = [self itemWithTitle:nil];
    item.customView = customView;
    return item;
}
@end
