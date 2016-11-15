//
//  HomeModel.h
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeCommentModel;

typedef NS_ENUM(NSInteger, HomeModelCellType) {
    HomeModelCellTypeComment = 0,
    HomeModelCellTypeVote
};

@interface HomeModel : NSObject
//头像
@property (copy, nonatomic) NSString *iconImV;
//姓名
@property (copy, nonatomic) NSString *name;
//项目
@property (copy, nonatomic) NSString *project;
//内容
@property (copy, nonatomic) NSString *content;
//图片数组
@property (strong, nonatomic) NSArray *photeNameArry;
//a投票数
@property (copy, nonatomic) NSString *aNum;
//b投票数
@property (copy, nonatomic) NSString *bNum;
//c投票数
@property (copy, nonatomic) NSString *cNum;
//时间
@property (copy, nonatomic) NSString *time;
//讨论数据
@property (strong, nonatomic) NSMutableArray *comment;
//时间节点所在的评论Model
@property (strong, nonatomic) HomeCommentModel *indexModel;
//时间节点下标
@property (assign, nonatomic) NSInteger index;
//是否展开
@property (assign, nonatomic) BOOL open;
//cell类型
@property (assign, nonatomic) HomeModelCellType cellType;

+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end


