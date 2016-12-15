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
            for (NSDictionary *dataDic in request.responseJSONObject[OBJ]) {
                [self.circles addObject:dataDic];
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
    }
    return _circles;
}

@end
