//
//  TTCommonArrowItem.h
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/5.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "TTCommonItem.h"

@interface TTCommonArrowItem : TTCommonItem
/**
 *  点击这行cell需要跳转的控制器
 */
@property (nonatomic, assign) Class destVcClass;

//@property (nonatomic, assign)  MJSettingArrowItemVcShowType  vcShowType;

+ (instancetype)itemWithIcon:(NSString *)icon title:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass;
+ (instancetype)itemWithTitle:(NSString *)title subtitle:(NSString *)subtitle destVcClass:(Class)destVcClass;
@end