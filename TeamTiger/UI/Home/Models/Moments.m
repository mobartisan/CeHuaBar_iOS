//
//  Moments.m
//  TeamTiger
//
//  Created by Dale on 17/3/8.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import "Moments.h"

@implementation Moments

- (instancetype)initWithBanner:(NSString *)bannerUrl list:(NSArray *)list {
    self = [super init];
    if (self) {
        self.bannerUrl = bannerUrl;
        self.list = list;
    }
    return self;
}
+ (instancetype)momentsWithBanner:(NSString *)bannerUrl list:(NSArray *)list {
    return [[self alloc] initWithBanner:bannerUrl list:list];
}

@end
