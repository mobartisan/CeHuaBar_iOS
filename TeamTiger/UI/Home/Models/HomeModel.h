//
//  HomeModel.h
//  BBSDemo
//
//  Created by Dale on 16/10/28.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HomeCommentModel;

@interface HomeModel : NSObject

@property (copy, nonatomic) NSString *iconImV;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *project;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *photeNameArry;
@property (copy, nonatomic) NSString *time;
@property (strong, nonatomic) NSMutableArray *comment;

@property (strong, nonatomic) HomeCommentModel *indexModel;
//时间节点下标
@property (assign, nonatomic) NSInteger index;
//是否展开
@property (assign, nonatomic) BOOL open;


+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end


