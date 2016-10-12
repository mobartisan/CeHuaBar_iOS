//
//  MockDatas.h
//  TeamTiger
//
//  Created by xxcao on 16/8/10.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockDatas : NSObject

//for test
+ (NSArray *)groups;

+ (NSArray *)projects;

+ (NSArray *)membersOfproject:(id)projectId;

+ (NSDictionary *)testerInfo;

@end
