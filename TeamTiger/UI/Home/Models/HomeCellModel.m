//
//  HomeCellModel.m
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "HomeCellModel.h"
#import "HomeDetailCellModel.h"

@implementation HomeCellModel



- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSDictionary *dict in self.comment) {
            HomeDetailCellModel *model = [HomeDetailCellModel modelWithDic:dict];
            [arr addObject:model];
        }
        self.comment = arr;
    }
    return self;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[HomeCellModel alloc] initWithDic:dic];
}

@end
