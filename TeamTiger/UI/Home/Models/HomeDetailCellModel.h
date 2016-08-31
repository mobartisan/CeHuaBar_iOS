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
/**
 *  时间
 */
@property (copy, nonatomic) NSString *time;
/**
 *  姓名
 */
@property (copy, nonatomic) NSString *firstName;
@property (copy, nonatomic) NSString *secondName;
/**
 *  描述
 */
@property (copy, nonatomic) NSString *des;
/**
 *  图片
 */
@property (copy, nonatomic) NSString *firstImage;
@property (copy, nonatomic) NSString *secondImage;
/**
 *  cell类型
 */
@property (assign, nonatomic) NSInteger typeCell;
/**
 *  是否展开
 */
@property (assign, nonatomic) BOOL isClick;
/**
 *  是否点击过
 */
@property (assign, nonatomic) BOOL isTap;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
