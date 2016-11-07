//
//  HomeModel.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeModel.h"
#import "HomeCommentModel.h"


@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        NSMutableArray *arr = [NSMutableArray array];
        if (self.comment != nil && ![self.comment isKindOfClass:[NSNull class]] && self.comment.count != 0) {
            HomeCommentModel *homeCommentModel = nil;
            for (int i = 0; i < self.comment.count; i++) {
                NSDictionary *dic = self.comment[i];
                HomeCommentModel *model = [HomeCommentModel homeCommentModelWithDict:dic];
                if (i != 0) {
                    HomeCommentModel *preModel = arr[i - 1];
                    if (![[model.time substringToIndex:4] isEqualToString:[preModel.time substringToIndex:4]]) {
                        preModel.show = YES;
                        self.index = i;
                        self.indexModel = preModel;
                        homeCommentModel = model;
                    }
                }
                [arr addObject:model];
            }
            [self modelWithModel:homeCommentModel arr:arr];
            _comment = arr;
        }
        
    }
    return self;
}

- (void)modelWithModel:(HomeCommentModel *)model arr:(NSMutableArray *)arr {
    NSDictionary *dic1 = @{@"name":[model.time substringToIndex:5],
                           @"sName":@"",
                           @"content":@"",
                           @"photeNameArry":@[],
                           @"time":@"这是时间节点"};
    HomeCommentModel *insertModel = [HomeCommentModel homeCommentModelWithDict:dic1];
    [arr insertObject:insertModel atIndex:self.index];
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[HomeModel alloc] initWithDic:dic];
}

@end



