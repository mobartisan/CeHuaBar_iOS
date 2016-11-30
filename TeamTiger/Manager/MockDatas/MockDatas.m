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
+ (NSArray *)groups {
    NSArray *groups = @[
                          @{@"Name":@"我管理的项目",@"Gid":@"00001",@"Pids":@"0001,0002"},
                          @{@"Name":@"我关注的项目",@"Gid":@"00002",@"Pids":@"0002,0004"},
                          @{@"Name":@"南京的项目",@"Gid":@"00003",@"Pids":@"0001,0002,0003,0004"},
                          @{@"Name":@"北京的项目",@"Gid":@"00004",@"Pids":@"0001,0003"}];
    return groups;
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

+ (NSArray *)unGroupedProjects {
    NSArray *unGroupedProjects = @[
                          @{@"Name":@"主网抢修",@"Id":@"0005"}];
    return unGroupedProjects;
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
                                             @"photeNameArry":@[@"image_2.jpg", @"image_6.jpg"],
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
    NSMutableArray *moments = [NSMutableArray array];
    for (NSDictionary *dic in resArray) {
        HomeModel *homeModel = [HomeModel modelWithDic:dic];
        [moments addObject:homeModel];
    }
    return moments;
}

@end
