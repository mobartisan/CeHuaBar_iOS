//
//  HomeCommentModel.h
//  BBSDemo
//
//  Created by Dale on 16/11/1.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCommentModel : NSObject

@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *sName;
@property (copy, nonatomic) NSString *content;
@property (strong, nonatomic) NSArray *photeNameArry;

@property (assign, nonatomic) BOOL show;
@property (assign, nonatomic) BOOL open;

+ (instancetype)homeCommentModelWithDict:(NSDictionary *)dic;

@end
