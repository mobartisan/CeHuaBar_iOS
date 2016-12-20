//
//  MockDatas.m
//  TeamTiger
//
//  Created by xxcao on 16/8/10.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "MockDatas.h"
#import "Models.h"
#import "HomeModel.h"

@implementation MockDatas



//for test
+ (NSMutableArray *)groups {
    NSMutableArray *groups = @[
                          @{@"Name":@"我管理的项目",@"Gid":@"00001",@"Pids":@"0001,0002"},
                          @{@"Name":@"我关注的项目",@"Gid":@"00002",@"Pids":@"0002,0004"},
                          @{@"Name":@"南京的项目",@"Gid":@"00003",@"Pids":@"0001,0002,0003,0004"},
                          @{@"Name":@"北京的项目",@"Gid":@"00004",@"Pids":@"0001,0003"}].mutableCopy;
    return groups;
}


+ (NSArray *)unGroupedProjects {
    NSArray *unGroupedProjects = @[
                          @{@"Name":@"主网抢修",@"Id":@"0005"}];
    return unGroupedProjects;
}

+ (NSArray *)projects {
    NSArray *projects = @[
                          @{@"Name":@"工作牛",@"Id":@"0001"},
                          @{@"Name":@"易会",@"Id":@"0002"},
                          @{@"Name":@"营配班组",@"Id":@"0003"},
                          @{@"Name":@"电动汽车",@"Id":@"0004"},
                          @{@"Name":@"主网抢修",@"Id":@"0005"}];
    return projects;
}

+ (NSArray *)groupedProjects {
    NSArray *groupedProjects = @[
                                 @{@"Name":@"工作牛",@"Id":@"0001"},
                                 @{@"Name":@"易会",@"Id":@"0002"},
                                 @{@"Name":@"营配班组",@"Id":@"0003"},
                                 @{@"Name":@"电动汽车",@"Id":@"0004"}];
    return groupedProjects;
}


+ (NSArray *)membersOfproject:(id)projectId {
    NSArray *members = nil;
    if ([projectId isEqualToString:@"0001"]) {
        members = @[@{@"Image":@"1.png",@"Name":@"曹兴星"},
                    @{@"Image":@"3.png",@"Name":@"刘鹏"},
                    @{@"Image":@"5.png",@"Name":@"陈杰"},
                    @{@"Image":@"7.png",@"Name":@"赵瑞"},
                    @{@"Image":@"9.png",@"Name":@"琳琳"},
                    @{@"Image":@"11.png",@"Name":@"俞弦"},
                    @{@"Image":@"13.png",@"Name":@"董宇鹏"},
                    @{@"Image":@"15.png",@"Name":@"齐云猛"},
                    @{@"Image":@"17.png",@"Name":@"焦兰兰"},
                    @{@"Image":@"2.png",@"Name":@"严必庆"},
                    @{@"Image":@"4.png",@"Name":@"陆毅全"}];
    }
    else if ([projectId isEqualToString:@"0002"]) {
        members = @[@{@"Image":@"11.png",@"Name":@"刘德华"},
                    @{@"Image":@"3.png",@"Name":@"张学友"},
                    @{@"Image":@"4.png",@"Name":@"郭富城"},
                    @{@"Image":@"6.png",@"Name":@"黎明"},
                    @{@"Image":@"9.png",@"Name":@"周星驰"},
                    @{@"Image":@"1.png",@"Name":@"周润发"},
                    @{@"Image":@"12.png",@"Name":@"成龙"},
                    @{@"Image":@"8.png",@"Name":@"张国荣"}];
    }
    else if ([projectId isEqualToString:@"0003"]) {
        members = @[@{@"Image":@"11.png",@"Name":@"葫芦娃"},
                    @{@"Image":@"3.png",@"Name":@"路飞"},
                    @{@"Image":@"4.png",@"Name":@"鸣人"},
                    @{@"Image":@"6.png",@"Name":@"黑猫警长"},
                    @{@"Image":@"9.png",@"Name":@"阿童木"},
                    @{@"Image":@"1.png",@"Name":@"沙加"},
                    @{@"Image":@"12.png",@"Name":@"穆先生"},
                    @{@"Image":@"7.png",@"Name":@"索隆"},
                    @{@"Image":@"13.png",@"Name":@"佐助"},
                    @{@"Image":@"14.png",@"Name":@"喜洋洋"},
                    @{@"Image":@"8.png",@"Name":@"灰太狼"},
                    @{@"Image":@"2.png",@"Name":@"白胡子"}];
    }
    else if ([projectId isEqualToString:@"0004"]) {
        members = @[@{@"Image":@"1.png",@"Name":@"郭靖"},
                    @{@"Image":@"2.png",@"Name":@"杨过"},
                    @{@"Image":@"3.png",@"Name":@"慕容复"},
                    @{@"Image":@"4.png",@"Name":@"胡斐"},
                    @{@"Image":@"5.png",@"Name":@"阿朱"},
                    @{@"Image":@"6.png",@"Name":@"杨铁心"},
                    @{@"Image":@"7.png",@"Name":@"李寻欢"},
                    @{@"Image":@"8.png",@"Name":@"花无缺"},
                    @{@"Image":@"9.png",@"Name":@"沈浪"},
                    @{@"Image":@"10.png",@"Name":@"陆小凤"},
                    @{@"Image":@"11.png",@"Name":@"楚留香"}];
    }

    return members;
}

+ (NSDictionary *)testerInfo {
    TT_User *user = [TT_User sharedInstance];
    if([Common isEmptyString:user.headimgurl] || [Common isEmptyString:user.nickname]){
        return @{@"HeadImage":@"http://up.qqjia.com/z/14/tu17250_12.jpg",@"Name":@"测试账号",@"Remarks":@"测试账号",@"Account":@"测试账号"};
    }
    NSDictionary *userInfo = @{@"HeadImage":user.headimgurl,@"Name":user.nickname,@"Remarks":user.nickname,@"Account":user.nickname};
    return userInfo;
}

//已废弃，供参考数据格式
+ (NSArray *)getMomentsWithId:(NSString *)tmpId IsProject:(BOOL)isProject IsAll:(BOOL)isAll {
    NSMutableArray *tmpArr = @[
                            @{@"cellType":@"0",
                              @"Id":@"0001",
                              @"iconImV":@"1",
                              @"name":@"唐小旭",
                              @"project":@"工作牛",
                              @"content":@"测试数据测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_4.jpg", @"image_4.jpg"],
                              @"time":@"7月17日 9:45",
                              @"comment":@[@{@"name":@"唐小旭",
                                             @"sName":@"@卞克",
                                             @"content":@"测试数据测试数据测试数据测试数据",
                                             @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_3.jpg", @"image_5.jpg"],
                                             @"time":@"11月21日 19:50"},
                                           @{@"name":@"卞克",
                                             @"sName":@"@唐小绪",
                                             @"content":@"哈哈哈",
                                             @"photeNameArry":@[],
                                             @"time":@"7月26日 13:55"},
                                           @{@"name":@"俞弦",
                                             @"sName":@"",
                                             @"content":@"有点意思",
                                             @"photeNameArry":@[],
                                             @"time":@"7月25日 14:17"},
                                           @{@"name":@"齐云猛",
                                             @"sName":@"",
                                             @"content":@"滴滴滴滴的",
                                             @"photeNameArry":@[],
                                             @"time":@"7月18日 9:30"}
                                           ].mutableCopy},
                            @{@"cellType":@"1",
                              @"Id":@"0002",
                              @"iconImV":@"2",
                              @"name":@"刘鹏",
                              @"project":@"易会",
                              @"content":@"测试数据测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_7.jpg"],
                              @"time":@"7月26日 9:45",
                              @"ticketArry":@[@"7", @"2", @"1"]
                              },
                            @{@"cellType":@"0",
                              @"Id":@"0003",
                              @"iconImV":@"9",
                              @"name":@"唐小旭",
                              @"project":@"营配班组",
                              @"content":@"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_1.jpg", @"image_2.jpg", @"image_3.jpg"],
                              @"time":@"7月20日 9:45",
                              @"comment":@[@{@"name":@"唐小旭",
                                             @"sName":@"@卞克",
                                             @"content":@"测试数据测试数据测试数据测试数据",
                                             @"photeNameArry":@[],
                                             @"time":@"11月22日 20:30"},
                                           @{@"name":@"曹兴星",
                                             @"sName":@"@唐小绪",
                                             @"content":@"哈哈哈",
                                             @"photeNameArry":@[@"image_1.jpg", @"image_2.jpg"],
                                             @"time":@"7月23日 15:05"},
                                           @{@"name":@"俞弦",
                                             @"sName":@"",
                                             @"content":@"有点意思",
                                             @"photeNameArry":@[],
                                             @"time":@"7月22日 12:01"},
                                           @{@"name":@"齐云猛",
                                             @"sName":@"",
                                             @"content":@"滴滴滴滴的",
                                             @"photeNameArry":@[],
                                             @"time":@"7月22日 11:30"},
                                           @{@"name":@"刘鹏",
                                             @"sName":@"",
                                             @"content":@"测试数据测试数据",
                                             @"photeNameArry":@[@"image_5.jpg", @"image_6.jpg"],
                                             @"time":@"7月20日 12:01"},
                                           @{@"name":@"齐云猛",
                                             @"sName":@"",
                                             @"content":@"滴滴滴滴的",
                                             @"photeNameArry":@[],
                                             @"time":@"7月20日 11:30"}
                                           ].mutableCopy},
                            @{@"cellType":@"0",
                              @"Id":@"0004",
                              @"iconImV":@"3",
                              @"name":@"曹兴星",
                              @"project":@"电动汽车",
                              @"content":@"测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_4.jpg"],
                              @"time":@"7月20日 9:45",
                              @"comment":@[@{@"name":@"唐小旭",
                                             @"sName":@"@卞克",
                                             @"content":@"测试数据测试数据测试数据测试数据",
                                             @"photeNameArry":@[@"image_8.jpg", @"image_9.jpg"],
                                             @"time":@"7月23日 20:30"},
                                           @{@"name":@"卞克",
                                             @"sName":@"@唐小绪",
                                             @"content":@"哈哈哈",
                                             @"photeNameArry":@[],
                                             @"time":@"7月23日 15:05"},
                                           @{@"name":@"俞弦",
                                             @"sName":@"",
                                             @"content":@"有点意思",
                                             @"photeNameArry":@[],
                                             @"time":@"7月23日 12:01"},
                                           @{@"name":@"齐云猛",
                                             @"sName":@"",
                                             @"content":@"滴滴滴滴的",
                                             @"photeNameArry":@[],
                                             @"time":@"7月22日 11:30"}
                                           ].mutableCopy},
                            @{@"cellType":@"0",
                              @"Id":@"0005",
                              @"iconImV":@"4",
                              @"name":@"赵瑞",
                              @"project":@"主网抢修",
                              @"content":@"测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_4.jpg", @"image_9.jpg"],
                              @"time":@"7月19日 9:45",
                              @"comment":@[@{@"name":@"唐小旭",
                                             @"sName":@"",
                                             @"content":@"测试数据测试数据测试数据测试数据",
                                             @"photeNameArry":@[],
                                             @"time":@"7月24日 20:30"},
                                           @{@"name":@"卞克",
                                             @"sName":@"@唐小绪",
                                             @"content":@"哈哈哈",
                                             @"photeNameArry":@[],
                                             @"time":@"7月24日 15:05"},
                                           @{@"name":@"俞弦",
                                             @"sName":@"",
                                             @"content":@"有点意思",
                                             @"photeNameArry":@[],
                                             @"time":@"7月21日 12:01"}
                                           ].mutableCopy},
                            @{@"cellType":@"0",
                              @"Id":@"0001",
                              @"iconImV":@"10",
                              @"name":@"曹兴星",
                              @"project":@"工作牛",
                              @"content":@"测试数据测试数据测试数据测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_4.jpg"],
                              @"time":@"8月16日 10:45",
                              @"comment":@[@{@"name":@"唐小旭",
                                             @"sName":@"",
                                             @"content":@"测试数据测试数据测试数据测试数据",
                                             @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg",@"image_1.jpg"],
                                             @"time":@"8月21日 19:50"},
                                           @{@"name":@"琳琳",
                                             @"sName":@"@卞克",
                                             @"content":@"哈哈哈哈哈哈哈哈哈",
                                             @"photeNameArry":@[],
                                             @"time":@"8月20日 13:55"},
                                           @{@"name":@"俞弦",
                                             @"sName":@"",
                                             @"content":@"有点意思有点意思",
                                             @"photeNameArry":@[@"image_2.jpg"],
                                             @"time":@"8月16日 20:17"},
                                           @{@"name":@"赵瑞",
                                             @"sName":@"",
                                             @"content":@"滴滴滴滴的滴滴滴滴的滴滴滴滴的",
                                             @"photeNameArry":@[],
                                             @"time":@"8月16日 16:31"}
                                           ].mutableCopy},
                            @{@"cellType":@"1",
                              @"Id":@"0005",
                              @"iconImV":@"2",
                              @"name":@"刘鹏",
                              @"project":@"主网抢修",
                              @"content":@"测试数据测试数据测试数据测试数据",
                              @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg", @"image_7.jpg",
                                                 @"image_1.jpg", @"image_8.jpg", @"image_5.jpg"],
                              @"time":@"11月24日 9:45",
                              @"ticketArry":@[@"7", @"2", @"1", @"3", @"5", @"9"]
                              }
                            ].mutableCopy;
    
    NSMutableArray *resArray = [NSMutableArray array];
    if (isAll) {
        [resArray addObjectsFromArray:tmpArr];
    }
    else {
        if (isProject) {
            //项目
            NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject[@"Id"] isEqualToString:tmpId];
            }];
            NSArray *arr = [tmpArr filteredArrayUsingPredicate:predicate];
            [resArray addObjectsFromArray:arr];
        } else {
            //分组
            NSArray *group = [[MockDatas groups] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                return [evaluatedObject[@"Gid"] isEqualToString:tmpId];
            }]];
            if (group && group.count > 0 && group.firstObject) {
                NSArray *pids = [group.firstObject[@"Pids"] componentsSeparatedByString:@","];
                NSArray *tmpMoments = [tmpArr filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
                    return [pids containsObject:evaluatedObject[@"Id"]];
                }]];
                [resArray addObjectsFromArray:tmpMoments];
            }
        }
    }
    //dictionary---> model
    return [MockDatas transeferModelsFromDictionarys:resArray];
}


+ (NSArray *)getMoments2WithId:(NSString *)tmpId IsProject:(BOOL)isProject IsAll:(BOOL)isAll {
    [SQLITEMANAGER setDataBasePath:[TT_User sharedInstance].user_id];
    NSArray *discusses = nil;
    if (isAll) {
        NSString *sql = [NSString stringWithFormat:@"select * from %@ order by create_date desc",TABLE_TT_Discuss];
        discusses = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Discuss];
    }
    else {
        if (isProject) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where project_id = '%@' order by create_date desc", TABLE_TT_Discuss, tmpId];
            discusses = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Discuss];
        } else {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where group_id = '%@'", TABLE_TT_Group, tmpId];
            TT_Group *group = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Group].firstObject;
            NSMutableString *mStr = [NSMutableString string];
            NSArray *pids = [group.pids componentsSeparatedByString:@","];
            for (NSString *str in pids) {
                [mStr appendFormat:@"'%@',",str];
            }
            [mStr replaceCharactersInRange:NSMakeRange(mStr.length - 1, 1) withString:NullString];
            sql = [NSString stringWithFormat:@"select * from %@ where project_id in (%@) order by create_date desc", TABLE_TT_Discuss, mStr];
            discusses = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Discuss];
        }
    }
    NSMutableArray *tmpDiscusses = [NSMutableArray array];
    for (TT_Discuss *discuss in discusses) {
        NSMutableDictionary *discussDic = [NSMutableDictionary dictionary];
        discussDic[@"cellType"] = @(discuss.discuss_type).stringValue;
        discussDic[@"Id"] = discuss.project_id;
        discussDic[@"iconImV"] = discuss.head_image_url;
        discussDic[@"name"] = discuss.user_name;
        discussDic[@"project"] = discuss.discuss_label;
        discussDic[@"content"] = discuss.content;
        discussDic[@"time"] = [Common handleDate:(NSString *)discuss.create_date];
        if (discuss.is_has_image) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where current_item_id = '%@'",TABLE_TT_Attachment,discuss.discuss_id];
            NSArray *attachments = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Attachment];
            NSMutableArray *images = [NSMutableArray array];
            for (TT_Attachment *attachment in attachments) {
                [images addObject:attachment.attachment_content];
            }
            discussDic[@"photeNameArry"] = images;
        }
        if (discuss.is_has_result) {
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where discuss_id = '%@'",TABLE_TT_Discuss_Result,discuss.discuss_id];
            NSArray *discuss_results = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Discuss_Result];
            NSMutableArray *results = [NSMutableArray array];
            for (TT_Discuss_Result *result in discuss_results) {
                [results addObject:result.discuss_result];
            }
            discussDic[@"ticketArry"] = results;
        }
        
        NSString *sql = [NSString stringWithFormat:@"select * from %@ where discuss_id = '%@'",TABLE_TT_Comment,discuss.discuss_id];
        NSArray *comments = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Comment];
        NSMutableArray *tmpComments = [NSMutableArray array];
        for (TT_Comment *comment in comments) {
            NSMutableDictionary *commentDic = [NSMutableDictionary dictionary];
            commentDic[@"name"] = comment.name;
            commentDic[@"sName"] = comment.at_name;
            commentDic[@"content"] = comment.content;
            commentDic[@"time"] = [Common handleDate:(NSString *)comment.create_date];
            
            NSString *sql = [NSString stringWithFormat:@"select * from %@ where current_item_id = '%@'",TABLE_TT_Attachment,comment.comment_id];
            NSArray *attachments = [SQLITEMANAGER selectDatasSql:sql Class:TABLE_TT_Attachment];
            NSMutableArray *images = [NSMutableArray array];
            for (TT_Attachment *attachment in attachments) {
                [images addObject:attachment.attachment_content];
            }
            commentDic[@"photeNameArry"] = images;
            [tmpComments addObject:commentDic];
        }
        discussDic[@"comment"] = tmpComments;

        [tmpDiscusses addObject:discussDic];
    }
    return [MockDatas transeferModelsFromDictionarys:tmpDiscusses];
}

#pragma -mark 字典 转 HomeModel
+ (NSMutableArray *)transeferModelsFromDictionarys:(NSMutableArray *)datas {
    //dictionary---> model
    NSMutableArray *discusses = [NSMutableArray array];
    for (NSDictionary *dic in datas) {
        HomeModel *homeModel = [HomeModel modelWithDic:dic];
        [discusses addObject:homeModel];
    }
    return discusses;
}

@end
