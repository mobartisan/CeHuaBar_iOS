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
    self.db = [FMDatabase databaseWithPath:[self getDataBasePath]];
}

//获取数据库文件路径的方法
- (NSString *)getDataBasePath {
    //1.获取documents文件夹路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    //2.拼接文件路径
    return [documentsPath stringByAppendingString:@"/Moments.sqlite"];
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
    [self.db executeUpdate:@"create table if not exists TT_Groups(group_id text, group_name text, banner text, list blob"];
    //3.关闭数据库
    [self.db close];
}

//存到数据库中
- (void)saveMomentsWithBanner:(NSString *)bannerUrl list:(NSArray *)list notification:(NSNotification *)notification {
    //1.删除原有数据
    [self deleteMomentsFromDBWithNotification:notification];
    //2.通过SQL操作数据
    NSDictionary *tmpDic = notification.userInfo;
    if (tmpDic && [tmpDic[@"IsGroup"] intValue] == 1) {//分组
        for (NSDictionary *dic in list) {
            NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
            BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Groups(group_id, banner, list) values (?, ?, ?)", [notification.object group_id], bannerUrl, listDic];
            NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
        }
    }else if (tmpDic && [tmpDic[@"IsGroup"] intValue] == 0) {//项目
        for (NSDictionary *dic in list) {
            NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
            BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Projects(project_id, banner, list) values (?, ?, ?)", dic[@"pid"][@"_id"], bannerUrl, listDic];
            NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
        }
    } else {//主页
        for (NSDictionary *dic in list) {
            NSData *listDic = [NSKeyedArchiver archivedDataWithRootObject:dic];
            BOOL isSuccess = [self.db executeUpdate:@"insert into TT_Moments(moment_id, banner, list) values (?, ?, ?)", dic[@"pid"][@"_id"], bannerUrl, listDic];
            NSLog(@"%@", isSuccess ? @"添加成功" : @"添加失败");
        }
    }
    //3.关闭数据库
    [self.db close];
}

//查询moments数据
- (Moments *)selectMomentsFromDataBaseWithNotification:(NSNotification *)notification {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (! isOpen) {
        return nil;
    }
    //2.通过SQL语句操作数据库 --- 查询所有的数据
    FMResultSet *result = nil;
    NSDictionary *tmpDic = notification.userInfo;
    if (tmpDic && [tmpDic[@"IsGroup"] intValue] == 1) {//分组
        result = [self.db executeQuery:@"select * from TT_Groups where group_id = ?", [notification.object group_id]];
    }else if (tmpDic && [tmpDic[@"IsGroup"] intValue] == 0) {//项目
        result = [self.db executeQuery:@"select * from TT_Projects where project_id = ?", [notification.object project_id]];
    } else {//主页
        result = [self.db executeQuery:@"select * from TT_Moments"];
    }
    
    NSString *bannerUrl = nil;
    NSMutableArray *tmpArr = [NSMutableArray array];
    //读取一条数据的每一个字段
    while ([result next]) {
        bannerUrl = [result stringForColumn:@"banner"];
        NSData *tmpData = [result objectForColumnName:@"list"];
        NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithData:tmpData];
        HomeModel *homeModel = [HomeModel modelWithDic:dic];
        [tmpArr addObject:homeModel];
    }
    //3.关闭数据库
    [self.db close];
    
    return [Moments momentsWithBanner:bannerUrl list:tmpArr];
}

//删除所有Moments数据
- (void)deleteMomentsFromDBWithNotification:(NSNotification *)notification {
    //1.打开数据库
    BOOL isOpen = [self.db open];
    if (! isOpen) {
        return;
    }
    //2.通过SQL语句操作数据库 --- 删除所有的数据
    NSDictionary *tmpDic = notification.userInfo;
    if (tmpDic && [tmpDic[@"IsGroup"] intValue] == 1) {//分组
        [self.db executeUpdate:@"delete from TT_Groups where group_id = ?", [notification.object group_id]];
    }else if (tmpDic && [tmpDic[@"IsGroup"] intValue] == 0) {//项目
        [self.db executeUpdate:@"delete from TT_Projects where project_id = ?", [notification.object project_id]];
    } else {//主页
        [self.db executeUpdate:@"delete from TT_Moments"];
    }
}

@end
