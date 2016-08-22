//
//  HomeDetailCellModel.h
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TypeCell) {
    TypeCellImage = 0,// 图片
    TypeCellTitleNoButton,//纯文字
    TypeCellTitle,//文字和按钮
    TypeCellTime//时间
};

@interface HomeDetailCellModel : NSObject

@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *secondName;
@property (copy, nonatomic) NSString *des;
@property (copy, nonatomic) NSString *firstImage;
@property (copy, nonatomic) NSString *secondImage;

@property (assign, nonatomic) NSInteger typeCell;
@property (assign, nonatomic) BOOL isClick;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
