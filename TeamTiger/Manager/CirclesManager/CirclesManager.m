//
//  CirclesManager.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CirclesManager.h"
#import "MBProgressHUD.h"

@implementation CirclesManager

+ (CirclesManager *)sharedInstance {
    
    static CirclesManager *circlesManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        circlesManager = [[self alloc] init];
    });
    return circlesManager;
}


#warning to do 获取所有项目的名称
- (void)loadingGlobalCirclesInfo {
    AllProjectsApi *allProject = [[AllProjectsApi alloc] init];
    [allProject startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"loadingGlobalCirclesInfo:%@", request.responseJSONObject);
        ;
        if (![Common isEmptyArr:request.responseJSONObject[OBJ]]) {
            for (NSDictionary *objDic in request.responseJSONObject[OBJ]) {
                [self.circles addObject:objDic];
                [self writeToSQLite:objDic];
            }
            self.selectIndex = 0;
            self.selectCircle = self.circles[_selectIndex];
        }
        
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.label.text = @"您的网络好像有问题~";
        hud.mode = MBProgressHUDModeText;
        [hud hideAnimated:YES afterDelay:1.5];
    }];
/*
    {
        code = 1000,
        success = 1,
        obj = (
               {
                   _id = 585358bc8458b4f534744db3,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 配抢
               },
               {
                   _id = 585359da8458b4f534744db6,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 项
               },
               {
                   _id = 58535aad8458b4f534744db9,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 目
               },
               {
                   _id = 58535b128458b4f534744dbc,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 项项目目
               },
               {
                   _id = 58535c948458b4f534744dc0,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 项目
               },
               {
                   _id = 5852ac9b0694d3a6384d7319,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 易会
               },
               {
                   _id = 5852ae830694d3a6384d731c,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 测试测试
               },
               {
                   _id = 5852a2237ae279d60a28cc45,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 测试项目
               },
               {
                   _id = 5852a43b7ae279d60a28cc67,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 营配
               },
               {
                   _id = 5852a7757ae279d60a28cc6b,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 主网抢修
               },
               {
                   _id = 58526ace4ff337ef5dfda4d1,
                   uid = e66cf590-c2ad-11e6-b03f-e7f688d8e0a6,
                   name = 工作牛
               }
               )
        ,
        msg = 查询成功
    }
    
  */
    
}


- (void)writeToSQLite:(NSDictionary *)projectDic {
        TT_User *user = [TT_User sharedInstance];
        [SQLITEMANAGER setDataBasePath:user.user_id];
        NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO %@(project_id, name) VALUES('%@','%@')",TABLE_TT_Project, projectDic[@"_id"], projectDic[@"name"]];
        [SQLITEMANAGER executeSql:sqlString];
    
}

- (void)setSelectIndex:(NSInteger)selectIndex {
    if (self.circles.count > selectIndex ) {
        _selectIndex = selectIndex;
        self.selectCircle = self.circles[selectIndex];
    } else
    {
        NSAssert(NO, @"set SelectIndex error.");
    }
}

- (NSMutableArray *)circles {
    if (!_circles) {
        _circles = [NSMutableArray array];
    }
    return _circles;
}

@end
