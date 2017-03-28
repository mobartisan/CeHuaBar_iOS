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
            singleton.cacheType = ECacheTypeDisk;
            singleton.mCache = [NSMutableDictionary dictionary];
            //1.创建数据库
            [singleton createDataBase];
            //2.创建表
            [singleton createTableInDataBase];
        }
    });
    return singleton;
}

- (id)getObjectForKey:(NSString *)key {
    if (!key || key.length == 0) {
        return nil;
    }
    if(self.cacheType == ECacheTypeMemory) {
        return [self.mCache objectForKey:key];
    } else {
        id object = UserDefaultsGet(key);
        
        NSString *dateKey = [NSString stringWithFormat:@"%@_Date",key];
        NSDate *dateObj = UserDefaultsGet(dateKey);
        
        NSString *timeInterValKey = [NSString stringWithFormat:@"%@_TimeInterval",key];
        NSNumber *timeIntervalObj = UserDefaultsGet(timeInterValKey);
        
        NSDate *now = [NSDate date];
        BOOL isTimeOut = now.timeIntervalSince1970 - dateObj.timeIntervalSince1970 >= timeIntervalObj.doubleValue;
        if (dateObj && timeIntervalObj && isTimeOut) {
            //缓存失效
            [self cleanCacheWithKey:key];
            [self cleanCacheWithKey:dateKey];
            [self cleanCacheWithKey:timeInterValKey];
            return nil;
        } else {
            if ([object isKindOfClass:[NSData class]]) {
                return [NSKeyedUnarchiver unarchiveObjectWithData:object];
            }
            else if ([object isKindOfClass:[NSArray class]]) {
                NSMutableArray *tmpArray = [NSMutableArray array];
                for (id obj in object) {
                    if ([obj isKindOfClass:[NSData class]]) {
                        id tmpObj = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                        [tmpArray addObject:tmpObj];
                    } else if ([obj isKindOfClass:[NSArray class]]) {
                        NSMutableArray *mObjs = [NSMutableArray array];
                        for (id model in obj) {
                            if ([model isKindOfClass:[NSData class]]) {
                                id tmpModel = [NSKeyedUnarchiver unarchiveObjectWithData:model];
                                [mObjs addObject:tmpModel];
                            } else {
                                [mObjs addObject:model];
                            }
                        }
                        [tmpArray addObject:mObjs];
                    } else {
                        [tmpArray addObject:obj];
                    }
                }
                return tmpArray;
            }
            else if ([object isKindOfClass:[NSDictionary class]]) {
                NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
                [object enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if ([obj isKindOfClass:[NSData class]]) {
                        id tmpObj = [NSKeyedUnarchiver unarchiveObjectWithData:obj];
                        tmpDic[key] = tmpObj;
                    } else {
                        tmpDic[key] = obj;
                    }
                }];
            }
            return object;
        }
    }
}

- (void)setObject:(id)object ForKey:(NSString *)key {
    if (!key || key.length == 0 || !object) {
        return;
    }
    if(self.cacheType == ECacheTypeMemory) {
        [self.mCache setObject:object forKey:key];
    } else {
        UserDefaultsSave(object, key);
    }
}

//根据时间
- (void)setObject:(id)object ForKey:(NSString *)key TimeOut:(NSTimeInterval)timeOut {
    if(timeOut <= 0){
        return;
    }
    [self setObject:object ForKey:key];
    
    if (self.cacheType == ECacheTypeMemory) {
        //自动计时
        __block NSTimeInterval tmpTimerInterval = timeOut;
        [NSTimer hyb_scheduledTimerWithTimeInterval:1.0 repeats:YES callback:^(NSTimer *timer) {
            if (tmpTimerInterval <= 0) {
                //
                [self cleanCacheWithKey:key];
                [timer hyb_invalidate];
            }
            tmpTimerInterval--;
        }];
    } else {
        NSString *dateKey = [NSString stringWithFormat:@"%@_Date",key];
        UserDefaultsSave([NSDate date], dateKey);
        
        NSString *timeInterValKey = [NSString stringWithFormat:@"%@_TimeInterval",key];
        UserDefaultsSave(@(timeOut), timeInterValKey);
    }
}

- (void)cleanCacheWithKey:(NSString *)key {
    if (!key || key.length == 0) {
        return;
    }
    if(self.cacheType == ECacheTypeMemory) {
        [self.mCache removeObjectForKey:key];
    } else {
        UserDefaultsRemove(key);
    }
}


#pragma mark  handle DataBase
//创建数据库
- (void)createDataBase {
    NSString *dbPath = [self getDataBasePath];
    if (![[NSFileManager defaultManager] fileExistsAtPath:dbPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:dbPath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    self.db = [FMDatabase databaseWithPath:dbPath];
}

//获取数据库文件路径的方法
- (NSString *)getDataBasePath {
    //1.获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接文件路径
    return [documentsPath stringByAppendingFormat:@"/%@.db", [TT_User sharedInstance].user_id];
}

//创建表
- (void)createTableInDataBase {
    
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (!isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 ---- 创建表
    [self.db executeUpdate:@"create table if not exists TT_Moments(moment_id text, banner text, list blob)"];
    [self.db executeUpdate:@"create table if not exists TT_Projects(project_id text, banner text, list blob)"];
    [self.db executeUpdate:@"create table if not exists TT_Groups(group_id text, group_name text, banner text, list blob)"];
    //3.关闭数据库
    [self.db close];
}

//存到数据库中
- (void)saveMomentsWithBanner:(NSString *)bannerUrl list:(NSArray *)list tempDic:(NSDictionary *)tempDic {
    
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
                BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Projects(project_id, banner) values (?, ?)", tempDic[@"pid"], bannerUrl];
                NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
            } else {
                for (NSDictionary *dic in list) {
                    NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Projects(project_id, banner, list) values (?, ?, ?)", dic[@"pid"][@"_id"], bannerUrl, listDic];
                    NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
                }
            }
        }
            break;
        case ECurrentIsGroup:
        {
            if ([Common isEmptyArr:list]) {
                BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Groups(group_id, banner) values (?, ?)", tempDic[@"gid"], bannerUrl];
                NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
            } else {
                for (NSDictionary *dic in list) {
                    NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Groups(group_id, banner, list) values (?, ?, ?)", tempDic[@"gid"], bannerUrl, listDic];
                    NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
                }
            }
        }
            break;
        case ECurrentIsAll:
        {
            if ([Common isEmptyArr:list]) {
                BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Moments(banner) values (?)", bannerUrl];
                NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
            } else {
                for (NSDictionary *dic in list) {
                    NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
                    BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Moments(moment_id, banner, list) values (?, ?, ?)", dic[@"pid"][@"_id"], bannerUrl, listDic];
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
            result = [self.db executeQuery:@"select * from TT_Projects where project_id = ?", tempDic[@"pid"]];
            break;
        case ECurrentIsGroup:
            result = [self.db executeQuery:@"select * from TT_Groups where group_id = ?", tempDic[@"gid"]];
            break;
        case ECurrentIsAll:
            result = [self.db executeQuery:@"select * from TT_Moments"];
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
    
    
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (! isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 --- 删除数据
    if(tempDic) {
        if (![tempDic.allKeys containsObject:@"pid"] &&
            ![tempDic.allKeys containsObject:@"gid"]) {//所有
            [self.db executeUpdate:@"delete from TT_Moments"];
        } else if ([tempDic.allKeys containsObject:@"pid"] &&
                   ![tempDic.allKeys containsObject:@"gid"]) {//项目
            [self.db executeUpdate:@"delete from TT_Projects where project_id = ?", tempDic[@"pid"]];
        } else if (![tempDic.allKeys containsObject:@"pid"] &&
                   [tempDic.allKeys containsObject:@"gid"]) {//分组
            [self.db executeUpdate:@"delete from TT_Groups where group_id = ?", tempDic[@"gid"]];
        } else {//所有
            [self.db executeUpdate:@"delete from TT_Moments"];
        }
    } else {//所有
        [self.db executeUpdate:@"delete from TT_Moments"];
    }
    //3.关闭数据库
    [self.db close];
}

- (void)updateBannerWithTempDic:(NSDictionary *)tempDic bannerUrl:(NSString *)bannerUrl {
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
            
          BOOL isSuccess =  [self.db executeUpdate:@"update TT_Projects set banner = ? where project_id = ?", bannerUrl, tempDic[@"pid"]];
            NSLog(@"%d", isSuccess);
        }
            break;
        case ECurrentIsGroup:
            [self.db executeUpdate:@"update TT_Groups set banner = ? where group_id = ?", bannerUrl, tempDic[@"gid"]];
            break;
        case ECurrentIsAll:
            [self.db executeUpdate:@"update TT_Moments set banner = ?", bannerUrl];
            break;
        default:
            break;
    }
    //3.关闭数据库
    [self.db close];
}

@end
