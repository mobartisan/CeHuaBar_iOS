//
//  CirclesManager.m
//  TeamTiger
//
//  Created by 刘鵬 on 16/8/9.
//  Copyright © 2016年 MobileArtisan. All rights reserved.
//

#import "CirclesManager.h"

@implementation CirclesManager

//static NSMutableArray *circles = nil;
+ (CirclesManager *)sharedInstance {
    
    static CirclesManager *circlesManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        circlesManager = [[self alloc] init];
    });
    
    return circlesManager;
}


- (void)loadingGlobalCirclesInfo {
#warning TO DO
    AllProjectsApi *allProject = [[AllProjectsApi alloc] init];
    [allProject startWithBlockSuccess:^(__kindof LCBaseRequest *request) {
        NSLog(@"%@-------", request.responseJSONObject);
        ;
        for (NSDictionary *dic in request.responseJSONObject[OBJ][DATA]) {
            
        }
        
    } failure:^(__kindof LCBaseRequest *request, NSError *error) {
        NSLog(@"%@", error);
        //        [super showHudWithText:@"获取项目失败"];
        //        [super hideHudAfterSeconds:1.0];
    }];
    //    {
    //        code = 1000,
    //        success = 0,
    //        obj = {
    //            data = (
    //                    {
    //                        _id = 5844e4d205bba03115f27a88,
    //                        uid = 30fb2a10-ba9c-11e6-8d67-8db0a5730ba6,
    //                        name = jlil,
    //                        description =
    //                    }
    //                    )
    //
    //        },
    //        msg = 查询成功
    //    }
    
    self.selectIndex = 0;
    self.selectCircle = self.circles[_selectIndex];
}

- (void)addCircle:(NSString *)circle {
    
}

- (void)delectCircleWithIndex:(NSInteger)index OrTitle:(NSString *)title {
    
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
        NSDictionary *dic = @{ @"_id": @"5844e4d205bba03115f27a88",
                               @"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",
                               @"name":@"工作牛",
                               @"description":@""};
        [_circles addObject:dic];
        
        NSDictionary *dic1 = @{ @"_id": @"5844e4d205bba03115f27a88",
                               @"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",
                               @"name":@"易会",
                               @"description":@"测试数据"};
        [_circles addObject:dic1];
        
        NSDictionary *dic2 = @{ @"_id": @"5844e4d205bba03115f27a88",
                               @"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",
                               @"name":@"主网抢修",
                               @"description":@"工作牛"};
        [_circles addObject:dic2];
        
        NSDictionary *dic3 = @{ @"_id": @"5844e4d205bba03115f27a88",
                               @"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",
                               @"name":@"MPP",
                               @"description":@"MPP"};
        [_circles addObject:dic3];
        
        NSDictionary *dic4 = @{ @"_id": @"5844e4d205bba03115f27a88",
                                @"uid":@"30fb2a10-ba9c-11e6-8d67-8db0a5730ba6",
                                @"name":@"营配",
                                @"description":@"营配"};
        [_circles addObject:dic4];
        
    }
    return _circles;
}

@end
