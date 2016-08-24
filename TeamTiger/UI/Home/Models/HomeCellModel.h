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

@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *headImage;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *type;
@property (copy, nonatomic) NSString *image1;
@property (copy, nonatomic) NSString *image2;
@property (copy, nonatomic) NSString *image3;
@property (copy, nonatomic) NSString *aDes;
@property (copy, nonatomic) NSString *bDes;
@property (copy, nonatomic) NSString *cDes;
@property (copy, nonatomic) NSString *aTicket;
@property (copy, nonatomic) NSString *bTicket;
@property (copy, nonatomic) NSString *cTicket;
@property (assign, nonatomic) BOOL isClick;

@property (assign, nonatomic) NSInteger projectType;
@property (strong, nonatomic) NSMutableArray *comment;
@property (assign, nonatomic) CGFloat height;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)modelWithDic:(NSDictionary *)dic;

@end
