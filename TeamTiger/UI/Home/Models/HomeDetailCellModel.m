//
//  HomeDetailCellModel.m
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeDetailCellModel.h"

@implementation HomeDetailCellModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[HomeDetailCellModel alloc] initWithDic:dic];
}

@end
