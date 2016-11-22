//
//  HomeModel.m
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeModel.h"
#import "NSString+Utils.h"
#import "HomeCommentModel.h"
#import "HomeCommentModelFrame.h"

@implementation HomeModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
        NSMutableArray *arr = [NSMutableArray array];
        //indexArr 存放时间节点的下标
        NSMutableArray *indexArr = [NSMutableArray array];
        //modelFrameArr 存放不同时间节点的modelFrame
        NSMutableArray *modelFrameArr = [NSMutableArray array];
        //y 用于 让判断只执行一次
        int y = 0;
        int commentCount = (int)self.comment.count;
        self.count = [NSString stringWithFormat:@"%d", commentCount];
        for (int i = 0; i < commentCount; i++) {
            NSDictionary *dic = self.comment[i];
            //model赋值
            HomeCommentModel *commentModel = [HomeCommentModel homeCommentModelWithDict:dic];
            HomeCommentModelFrame *commentModelFrame = [[HomeCommentModelFrame alloc] init];
            commentModelFrame.homeCommentModel = commentModel;
            if (i != 0)  {
                HomeCommentModelFrame *preCommentModelFrame = arr[i - 1];
                if (![[commentModelFrame.homeCommentModel.time substringToIndex:4] isEqualToString:[preCommentModelFrame.homeCommentModel.time substringToIndex:4]]) {
                    if (y < 1) {
                        preCommentModelFrame.homeCommentModel.show = YES;
                        if (indexArr.count == 1) {
                            self.index = i + 1;
                        } else {
                             self.index = i;
                        }
                        self.indexModel = preCommentModelFrame;
                        y++;
                    }
                    [indexArr addObject:@(i)];
                    [modelFrameArr addObject:commentModelFrame];
                }
            }else {
                NSString *firDate = [[commentModelFrame.homeCommentModel.time componentsSeparatedByString:@" "] firstObject];
                NSString *currentDate = [Common getCurrentSystemDate];
                Common *common = [[Common alloc] init];
                if ([common differencewithDate:firDate withDate:currentDate].day > 0) {
                    [indexArr addObject:@(i)];
                    [modelFrameArr addObject:commentModelFrame];
                }
            }
            [arr addObject:commentModelFrame];
        }
        _comment = arr;
        
        //插入时间节点model
        int indexCount = (int)indexArr.count;
        for (int i = 0; i < indexCount; i++) {
            HomeCommentModelFrame *modelFrame = modelFrameArr[i];
            NSArray *strArr = [modelFrame.homeCommentModel.time componentsSeparatedByString:@" "];
            NSString *month = [strArr firstObject];
            NSDictionary *dic1 = @{@"name": month,
                                   @"sName":@"时间节点"};
            HomeCommentModel *commentModel = [HomeCommentModel homeCommentModelWithDict:dic1];
            HomeCommentModelFrame *commentModelFrame = [[HomeCommentModelFrame alloc] init];
            commentModelFrame.homeCommentModel = commentModel;
            int index = [indexArr[i] intValue] + i;
            [_comment insertObject:commentModelFrame atIndex:index];
        }
        self.totalHeight = [self caculteCellHeight:self.comment.count];
        self.partHeight = [self caculteCellHeight:self.index];
    }
    return self;
}

- (CGFloat)caculteCellHeight:(NSInteger)count {
    CGFloat totalHeight = 0;
    for (NSInteger i = 0; i < count; i++) {
        totalHeight += ((HomeCommentModelFrame *)self.comment[i]).cellHeight;;
    }
    return totalHeight;
}


+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[HomeModel alloc] initWithDic:dic];
}

@end



