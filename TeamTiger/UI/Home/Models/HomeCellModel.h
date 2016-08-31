//
//  HomeCellModel.h
//  TeamTiger
//
//  Created by Dale on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ProjectType) {
    ProjectTypeAll = 0,
    ProjectTypeCattle, //工作牛
    ProjectTypeEMeeting, //易会
    ProjectTypeMPP, //MPP
    ProjectTypeMarket, //营配
    ProjectTypeVote//投票
};

@interface HomeCellModel : NSObject
/**
 *  时间
 */
@property (copy, nonatomic) NSString *time;
/**
 *  头像
 */
@property (copy, nonatomic) NSString *headImage;
/**
 *  姓名
 */
@property (copy, nonatomic) NSString *name;
/**
 *  项目名称
 */
@property (copy, nonatomic) NSString *type;
/**
 *  图片
 */
@property (copy, nonatomic) NSString *image1;
@property (copy, nonatomic) NSString *image2;
@property (copy, nonatomic) NSString *image3;
@property (copy, nonatomic) NSString *image4;
/**
 *  描述
 */
@property (copy, nonatomic) NSString *aDes;
@property (copy, nonatomic) NSString *bDes;
@property (copy, nonatomic) NSString *cDes;
/**
 *  票数
 */
@property (copy, nonatomic) NSString *aTicket;
@property (copy, nonatomic) NSString *bTicket;
@property (copy, nonatomic) NSString *cTicket;
//是否投票
@property (assign, nonatomic) BOOL aIsClick;
@property (assign, nonatomic) BOOL bIsClick;
@property (assign, nonatomic) BOOL cIsClick;
//cell是否点击
@property (assign, nonatomic) BOOL isClick;

//cell类型
@property (assign, nonatomic) NSInteger projectType;
/**
 *  评论数
 */
@property (strong, nonatomic) NSMutableArray *comment;
/**
 *  cell的高度
 */
@property (assign, nonatomic) CGFloat height;
/**
 *  图片个数
 */
@property (assign, nonatomic) NSInteger imageCount;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
