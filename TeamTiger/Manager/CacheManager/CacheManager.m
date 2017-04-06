//
//  CacheManager.m
//  TeamTiger
//
//  Created by xxcao on 16/8/1.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CacheManager.h"
#import "NSTimer+HYBHelperKit.h"
#import "FMDatabase.h"
#import "Moments.h"
#import "HomeModel.h"


@interface CacheManager()

@property (nonatomic, strong) FMDatabase *db;

@end

@implementation CacheManager

static CacheManager *singleton = nil;
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!singleton) {
            singleton = [[[self class] alloc] init];
            //1.创建数据库
            [singleton createDataBase];
            //2.创建表
            [singleton createTableInDataBase];
        }
    });
    return singleton;
}

#pragma mark  handle DataBase
//创建数据库
- (void)createDataBase {
    self.db = [FMDatabase databaseWithPath:[self getDataBasePath]];
}

//获取数据库文件路径的方法
- (NSString *)getDataBasePath {
    //1.获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接文件路径
    return [documentsPath stringByAppendingFormat:@"/Moments.sqlite"];
}

//创建表
- (void)createTableInDataBase {
    
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 ---- 创建表
    [self.db executeUpdate:@"create table if not exists TT_Moments(user_id text, moment_id text, banner text, list blob)"];
    [self.db executeUpdate:@"create table if not exists TT_Projects(user_id text, project_id text, banner text, list blob)"];
    [self.db executeUpdate:@"create table if not exists TT_Groups(user_id text, group_id text, banner text, list blob)"];
    //3.关闭数据库
    [self.db close];
}

//存到数据库中
- (void)saveMomentsWithBanner:(NSString *)bannerUrl list:(NSArray *)list tempDic:(NSDictionary *)tempDic {
     NSString *user_id = [TT_User sharedInstance].user_id;
    //1.删除原有数据
    [self deleteMomentsFromDBWithTempDic:tempDic];
    
    //2.打开数据库
    BOOL isOpen = [self.db open];
    if (! isOpen) {
        return ;
    }
    //3.通过SQL操作数据
    ECurrentStatus currentStatus = [self isProejctOrGroupOrAllByCurrently:tempDic];
    switch (currentStatus) {
        case ECurrentIsProject:
        {
            if ([Common isEmptyArr:list]) {
                BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Projects(user_id, project_id, banner) values (?, ?, ?)", user_id, tempDic[@"pid"], bannerUrl];
                NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
            } else {
                for (NSDictionary *dic in list) {
                    NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Projects(user_id, project_id, banner, list) values (?, ?, ?, ?)", user_id, dic[@"pid"][@"_id"], bannerUrl, listDic];
                    NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
                }
            }
        }
            break;
        case ECurrentIsGroup:
        {
            if ([Common isEmptyArr:list]) {
                BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Groups(user_id, group_id, banner) values (?, ?, ?)", user_id, tempDic[@"gid"], bannerUrl];
                NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
            } else {
                for (NSDictionary *dic in list) {
                    NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Groups(user_id, group_id, banner, list) values (?, ?, ?, ?)", user_id, tempDic[@"gid"], bannerUrl, listDic];
                    NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
                }
            }
        }
            break;
        case ECurrentIsAll:
        {
            if ([Common isEmptyArr:list]) {
                BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Moments(user_id, banner) values (?, ?)", user_id, bannerUrl];
                NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
            } else {
                for (NSDictionary *dic in list) {
                    NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Moments(user_id, moment_id, banner, list) values (?, ?, ?, ?)", user_id, dic[@"pid"][@"_id"], bannerUrl, listDic];
                    NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
                }
            }
        }
            break;
        default:
            break;
    }
    //4.关闭数据库
    [self.db close];
}

//MARK: - 当前是否是项目、分组、还是所有
- (ECurrentStatus)isProejctOrGroupOrAllByCurrently:(NSDictionary *)tempDic {
    ECurrentStatus currentStatus;
    if(tempDic) {
        if (![tempDic.allKeys containsObject:@"pid"] &&
            ![tempDic.allKeys containsObject:@"gid"]) {
            currentStatus = ECurrentIsAll;
        } else if ([tempDic.allKeys containsObject:@"pid"] &&
                   ![tempDic.allKeys containsObject:@"gid"]) {
            currentStatus = ECurrentIsProject;
        } else if (![tempDic.allKeys containsObject:@"pid"] &&
                   [tempDic.allKeys containsObject:@"gid"]) {
            currentStatus = ECurrentIsGroup;
        } else {
            currentStatus = ECurrentIsAll;
        }
    } else {
        currentStatus = ECurrentIsAll;
    }
    return currentStatus;
}

//查询moments数据
- (Moments *)selectMomentsFromDataBaseWithTempDic:(NSDictionary *)tempDic {
    NSString *user_id = [TT_User sharedInstance].user_id;
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return nil;
    }
    //2.通过SQL语句操作数据库 --- 查询所有的数据
    FMResultSet *result = nil;
    ECurrentStatus currentStatus = [self isProejctOrGroupOrAllByCurrently:tempDic];
    switch (currentStatus) {
        case ECurrentIsProject:
            result = [self.db executeQuery:@"select * from TT_Projects where project_id = ? and user_id = ?", tempDic[@"pid"], user_id];
            break;
        case ECurrentIsGroup:
            result = [self.db executeQuery:@"select * from TT_Groups where group_id = ? and user_id = ?", tempDic[@"gid"], user_id];
            break;
        case ECurrentIsAll:
            result = [self.db executeQuery:@"select * from TT_Moments where user_id = ?", user_id];
            break;
        default:
            break;
    }
    
    NSString *bannerUrl = nil;
    NSMutableArray *tmpArr = [NSMutableArray array];
    //读取一条数据的每一个字段
    while ([result next]) {
        bannerUrl = [result stringForColumn:@"banner"];
        //list字段对应的值为空时的安全处理
        if (![[result objectForColumnName:@"list"] isKindOfClass:[NSNull class]]) {
            NSData *tmpData = [result objectForColumnName:@"list"];
            NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:tmpData];
            HomeModel *homeModel = [HomeModel modelWithDic:dic];
            [tmpArr addObject:homeModel];
        }
    }
    //3.关闭数据库
    [self.db close];
    
    return [Moments momentsWithBanner:bannerUrl list:tmpArr];
}


//删除所有Moments数据
- (void)deleteMomentsFromDBWithTempDic:(NSDictionary *)tempDic {
    NSString *user_id = [TT_User sharedInstance].user_id;
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (! isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 --- 删除数据
    if(tempDic) {
        if (![tempDic.allKeys containsObject:@"pid"] &&
            ![tempDic.allKeys containsObject:@"gid"]) {//所有
            [self.db executeUpdate:@"delete from TT_Moments where user_id = ?", user_id];
        } else if ([tempDic.allKeys containsObject:@"pid"] &&
                   ![tempDic.allKeys containsObject:@"gid"]) {//项目
            [self.db executeUpdate:@"delete from TT_Projects where project_id = ? and user_id = ?", tempDic[@"pid"], user_id];
        } else if (![tempDic.allKeys containsObject:@"pid"] &&
                   [tempDic.allKeys containsObject:@"gid"]) {//分组
            [self.db executeUpdate:@"delete from TT_Groups where group_id = ? and user_id = ?", tempDic[@"gid"], user_id];
        } else {//所有
            [self.db executeUpdate:@"delete from TT_Moments where user_id = ?", user_id];
        }
    } else {//所有
        [self.db executeUpdate:@"delete from TT_Moments where user_id = ?", user_id];
    }
    //3.关闭数据库
    [self.db close];
}

- (void)updateBannerWithTempDic:(NSDictionary *)tempDic bannerUrl:(NSString *)bannerUrl {
    NSString *user_id = [TT_User sharedInstance].user_id;
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (! isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库
    ECurrentStatus currentStatus = [self isProejctOrGroupOrAllByCurrently:tempDic];
    switch (currentStatus) {
        case ECurrentIsProject:
        {
            
          BOOL isSuccess =  [self.db executeUpdate:@"update TT_Projects set banner = ? where project_id = ? and user_id = ?", bannerUrl, tempDic[@"pid"], user_id];
            NSLog(@"%d", isSuccess);
        }
            break;
        case ECurrentIsGroup:
            [self.db executeUpdate:@"update TT_Groups set banner = ? where group_id = ? and user_id = ?", bannerUrl, tempDic[@"gid"], user_id];
            break;
        case ECurrentIsAll:
            [self.db executeUpdate:@"update TT_Moments set banner = ? where user_id = ?", bannerUrl, user_id];
            break;
        default:
            break;
    }
    //3.关闭数据库
    [self.db close];
}

@end
