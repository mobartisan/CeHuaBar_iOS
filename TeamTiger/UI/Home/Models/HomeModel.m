//
//  HomeModel.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeModel.h"
#import "HomeCommentModel.h"
#import "HomeCommentModelFrame.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        NSMutableArray *arr = [NSMutableArray array];
        int commentCount = (int)self.comment.count;
        for (int i = 0; i < commentCount; i++) {
            NSDictionary *dic = self.comment[i];
            HomeCommentModel *model = [HomeCommentModel homeCommentModelWithDict:dic];
            HomeCommentModelFrame *modelFrame = [[HomeCommentModelFrame alloc] init];
            modelFrame.homeCommentModel = model;
            if (i != 0) {
                HomeCommentModelFrame *preModel = arr[i - 1];
                if (![[modelFrame.homeCommentModel.time substringToIndex:4] isEqualToString:[preModel.homeCommentModel.time substringToIndex:4]]) {
                    preModel.homeCommentModel.show = YES;
                    self.index = i ;
                    self.indexModel = preModel;
                }
            }
            [arr addObject:modelFrame];
        }
        _comment = arr;
        
        self.totalHeight = [self caculteCellTotalHeight];
        self.partHeight = [self caculteCellPartHeight];
    }
    return self;
}

- (CGFloat)caculteCellTotalHeight {
    CGFloat totalHeight = 0;
    int count = (int)self.comment.count;
    for (int i = 0; i < count; i++) {
        totalHeight += ((HomeCommentModelFrame *)self.comment[i]).cellHeight;;
    }
    return totalHeight;
}

- (CGFloat)caculteCellPartHeight {
    CGFloat partHeight = 0;
    for (int i = 0; i < self.index; i++) {
        partHeight += ((HomeCommentModelFrame *)self.comment[i]).cellHeight;;
    }
    return partHeight;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[HomeModel alloc] initWithDic:dic];
}

@end



