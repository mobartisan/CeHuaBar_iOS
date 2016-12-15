//
//  HomeModel.h
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeCommentModelFrame;

typedef NS_ENUM(int, HomeModelCellType) {
    HomeModelCellTypeComment = 0,
    HomeModelCellTypeVote
};

@interface HomeModel : NSObject
//项目id
@property (copy, nonatomic) NSString *Id;
//头像
@property (copy, nonatomic) NSString *iconImV;
//姓名
@property (copy, nonatomic) NSString *name;
//项目
@property (copy, nonatomic) NSString *project;
//内容
@property (copy, nonatomic) NSString *content;
//图片数组
@property (strong, nonatomic) NSMutableArray *photeNameArry;
//投票总数
@property (assign, nonatomic) int vcount;
//时间
@property (copy, nonatomic) NSString *time;
//讨论数据
@property (strong, nonatomic) NSMutableArray *comment;
//投票数据
@property (strong, nonatomic) NSMutableArray *vote;
//mid  moment的id
@property (copy, nonatomic) NSString *moment_id;
//讨论数据的个数
@property (copy, nonatomic) NSString *count;

//时间节点所在的评论Model
@property (strong, nonatomic) HomeCommentModelFrame *indexModel;

//时间节点下标
@property (assign, nonatomic) NSInteger index;
//是否展开
@property (assign, nonatomic) BOOL open;
//cell类型
@property (assign, nonatomic) HomeModelCellType cellType;

//总高度
@property (nonatomic, assign) CGFloat totalHeight;
//部分高度
@property (nonatomic, assign) CGFloat partHeight;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end


