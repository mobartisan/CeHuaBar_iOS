//
//  MockDatas.m
//  TeamTiger
//
//  Created by xxcao on 16/8/10.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "MockDatas.h"
#import "Models.h"

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
  @{@"Name":@"电动汽车",@"Id":@"0004"}];
    return projects;
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

@end
