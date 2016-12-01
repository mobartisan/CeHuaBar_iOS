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
+ (NSMutableArray *)groups;

+ (NSArray *)projects;

+ (NSArray *)unGroupedProjects;

+ (NSArray *)groupedProjects;

+ (NSArray *)membersOfproject:(id)projectId;

+ (NSDictionary *)testerInfo;

+ (NSArray *)getMomentsWithId:(NSString *)tmpId IsProject:(BOOL)isProject IsAll:(BOOL)isAll;

@end
