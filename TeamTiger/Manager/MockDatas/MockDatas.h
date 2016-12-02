//
//  MockDatas.h
//  TeamTiger
//
//  Created by xxcao on 16/8/10.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockDatas : NSObject

+ (NSDictionary *)testerInfo;

+ (NSArray *)getMoments2WithId:(NSString *)tmpId IsProject:(BOOL)isProject IsAll:(BOOL)isAll;

@end
