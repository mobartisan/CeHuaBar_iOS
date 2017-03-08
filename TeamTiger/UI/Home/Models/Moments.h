//
//  Moments.h
//  TeamTiger
//
//  Created by Dale on 17/3/8.
//  Copyright © 2017年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>
//banner blob, newscount text, list blob, next text
@interface Moments : NSObject
@property (nonatomic,copy) NSString *bannerUrl;
@property (nonatomic,strong) NSArray *list;


- (instancetype)initWithBanner:(NSString *)bannerUrl list:(NSArray *)list;
+ (instancetype)momentsWithBanner:(NSString *)bannerUrl list:(NSArray *)list ;

@end
