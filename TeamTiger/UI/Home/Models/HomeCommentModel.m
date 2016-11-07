//
//  HomeCommentModel.m
//  BBSDemo
//
//  Created by Dale on 16/11/1.
//  Copyright © 2016年 Nari. All rights reserved.
//

#import "HomeCommentModel.h"

@implementation HomeCommentModel

+ (instancetype)homeCommentModelWithDict:(NSDictionary *)dic {
    return [[self alloc] initWithDict:dic];
}

- (instancetype)initWithDict:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

@end
