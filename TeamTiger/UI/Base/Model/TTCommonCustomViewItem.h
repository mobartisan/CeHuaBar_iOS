//
//  TTCommonCustomViewItem.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/18.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonItem.h"

@interface TTCommonCustomViewItem : TTCommonItem

@property(nonatomic, strong)UIView *customView;

+ (instancetype)itemWithCustomView:(UIView *)customView;
@end
