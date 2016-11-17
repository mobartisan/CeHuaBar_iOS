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
        NSMutableArray *indexArr = [NSMutableArray array];
        NSMutableArray *modelFrameArr = [NSMutableArray array];
        int y = 0;
        int commentCount = (int)self.comment.count;
        _count = [NSString stringWithFormat:@"%d", commentCount];
        for (int i = 0; i < commentCount; i++) {
            NSDictionary *dic = self.comment[i];
            HomeCommentModel *commentModel = [HomeCommentModel homeCommentModelWithDict:dic];
            HomeCommentModelFrame *commentModelFrame = [[HomeCommentModelFrame alloc] init];
            commentModelFrame.homeCommentModel = commentModel;
            if (i != 0) {
                HomeCommentModelFrame *preModelFrame = arr[i - 1];
                if (![[commentModelFrame.homeCommentModel.time substringToIndex:4] isEqualToString:[preModelFrame.homeCommentModel.time substringToIndex:4]]) {
                    if (y < 1) {
                        preModelFrame.homeCommentModel.show = YES;
                        self.index = i ;
                        self.indexModel = preModelFrame;
                        y++;
                    }
                    [indexArr addObject:@(i)];
                    [modelFrameArr addObject:commentModelFrame];
                }
            }
            [arr addObject:commentModelFrame];
        }
        _comment = arr;
        int indexCount = (int)indexArr.count;
        for (int i = 0; i < indexCount; i++) {
            HomeCommentModelFrame *modelFrame = modelFrameArr[i];
            NSArray *strArr = [modelFrame.homeCommentModel.time componentsSeparatedByString:@" "];
            NSString *month = [strArr firstObject];
            NSString *time = [strArr lastObject];
            NSDictionary *dic1 = @{@"name": month,
                                   @"time":[NSString stringWithFormat:@"%@ %@", time, time],
                                   @"sName":@"时间节点"};
            HomeCommentModel *commentModel = [HomeCommentModel homeCommentModelWithDict:dic1];
            HomeCommentModelFrame *commentModelFrame = [[HomeCommentModelFrame alloc] init];
            commentModelFrame.homeCommentModel = commentModel;
            int index = [indexArr[i] intValue] + i;
            [_comment insertObject:commentModelFrame atIndex:index];
        }
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



