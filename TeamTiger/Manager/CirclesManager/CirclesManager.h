//
//  CirclesManager.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    OptionSingle = 0,
    OptionMultiple,
} OptionType;

@interface CirclesManager : NSObject

+ (instancetype)sharedInstance;

- (void)loadingGlobalCirclesInfo;

- (void)addCircle:(NSString *)circle;

- (void)delectCircleWithIndex:(NSInteger)index OrTitle:(NSString *)title;

@property(nonatomic, strong) NSMutableArray *circles;


@property(nonatomic, strong) NSDictionary *selectCircle;
@property(nonatomic, assign) NSInteger selectIndex;
@property(nonatomic, assign) OptionType optionType;
@end
